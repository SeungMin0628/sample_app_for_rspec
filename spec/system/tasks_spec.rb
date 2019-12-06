require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  let!(:task) { create :task }
  feature 'before login' do
    shared_examples 'not auth' do
      scenario { expect(current_path).to eq login_path }
      scenario { expect(page).to have_content 'Login required' }
    end

    feature '#new' do
      background do
        visit new_task_path
      end

      it_behaves_like 'not auth'
    end

    feature '#edit' do
      background do
        visit edit_task_path(task)
      end

      it_behaves_like 'not auth'
    end

    feature '#destroy' do
      scenario "Guest can't destroy a task" do
        expect {
          visit task_path(task, method: :delete)
        }.to change{ Task.count }.by(0)
      end
    end
  end

  feature 'after login' do
    given(:user) { create :user }
    given(:own_task) { user.tasks.create(title: 'Example Title', content: 'Example Content', status: :todo) }
    background do
      login_as user
    end

    feature '#new' do
      scenario 'User can create a task' do
        title = 'Example Title'
        content = 'Example Content'
        status = %i[todo doing done].sample.to_s

        create_task(title: title, content: content, status: status)
        expect(page).to have_content 'Task was successfully created.'
        expect(page).to have_content title
        expect(page).to have_content content
        expect(page).to have_content status
      end

      scenario "User can't create a task without title" do
        content = 'Example Content'
        status = %i[todo doing done].sample.to_s

        create_task(title: nil, content: content, status: status)
        expect(page).to have_content "Title can't be blank"
      end
      
      scenario "User can't create a task use a duplicate title" do
        title = task.title
        content = 'Example Content'
        status = %i[todo doing done].sample.to_s

        create_task(title: title, content: content, status: status)
        expect(page).to have_content "Title has already been taken"
      end
    end

    feature '#edit' do
      scenario 'User can edit a task' do
        title = 'Updated Title'
        content = 'Updated Content'
        status = %i[todo doing done].sample.to_s

        update_task(task: own_task, title: title, content: content, status: status)
        expect(page).to have_content "Task was successfully updated."
      end

      scenario "User can't edit a task without title" do
        content = 'Updated Content'
        status = %i[todo doing done].sample.to_s

        update_task(task: own_task, title: nil, content: content, status: status)
        expect(page).to have_content "Title can't be blank"
      end

      scenario "User can't edit a task use a duplicate title" do
        title = task.title
        content = 'Updated Content'
        status = %i[todo doing done].sample.to_s

        update_task(task: own_task, title: title, content: content, status: status)
        expect(page).to have_content "Title has already been taken"
      end

      scenario "User can't access another user's edit task page" do
        visit edit_task_path(task)
        expect(page).to have_content 'Forbidden access.'
      end
    end

    feature '#destory' do
      scenario 'User can delete own task' do
        expect {
          visit task_path(own_task, method: :delete)
        }.to change{ Task.count }.by(1)
      end

      scenario "User can't delete another user's task" do
        expect {
          visit task_path(task, method: :delete)
        }.to change{ Task.count }.by(0)
      end
    end
  end
end

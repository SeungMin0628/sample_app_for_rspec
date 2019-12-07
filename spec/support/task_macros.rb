module TaskMacros
  def create_task(title:, content:, status:)
    visit new_task_path
    fill_in 'Title', with: title
    fill_in 'Content', with: content
    select status, from: 'Status'
    click_button 'Create Task'
  end

  def update_task(task:, title:, content:, status:)
    visit edit_task_path(task)
    fill_in 'Title', with: title
    fill_in 'Content', with: content
    select status, from: 'Status'
    click_button 'Update Task'
  end
end

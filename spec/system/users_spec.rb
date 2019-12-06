require 'rails_helper'

RSpec.describe 'Users', type: :system do
  given(:user) { create :user }
  given(:other_user) { create :user }

  feature 'before login' do
    feature '#root' do
      background do
        visit root_path
      end

      scenario 'Guest can access sign up page' do
        expect(page).to have_link('SignUp', href: sign_up_path)
        click_on 'SignUp'
        expect(current_path).to eq sign_up_path
      end

      scenario 'Guest can access login page' do
        expect(page).to have_link('Login', href: login_path)
        click_on 'Login'
        expect(current_path).to eq login_path
      end
    end

    feature '#login' do
      feature 'valid' do
        scenario 'Guest can login with valid email and password' do
          login_as user
        end
      end

      feature 'invalid' do
        scenario "Guest can't login without inputting form" do
          try_login(email: '', password: '')

          expect(current_path).to eq login_path
          expect(page).to have_content 'Login failed'
        end

        scenario "Guest can't login when inputted wrong password" do
          try_login(email: user.email, password: 'invalid')

          expect(current_path).to eq login_path
          expect(page).to have_content 'Login failed'
        end
      end
    end

    feature '#sign_up' do
      given(:new_user) { build :user }

      feature 'valid' do
        scenario 'Guest can sign up with valid email and password' do
          sign_up_form_with(email: new_user.email, password: 'secret', password_confirmation: 'secret')

          # expect create user success, show flash message
          expect(current_path).to eq login_path
          expect(User.find_by(email: new_user.email)).not_to be_nil
          expect(page).to have_content 'User was successfully created.'
        end
      end

      feature 'invalid' do
        scenario "Guest can't sign up when they doesn't inputted email" do
          sign_up_form_with(email: nil, password: 'secret', password_confirmation: 'secret')

          expect(page).to have_content "Email can't be blank"
        end

        scenario "Guest can't sign up when inputted email is already exists" do
          sign_up_form_with(email: user.email, password: 'secret', password_confirmation: 'secret')

          expect(page).to have_content 'Email has already been taken'
        end

        scenario "Guest can't sign up when password is shorter than 3 characters" do
          sign_up_form_with(email: new_user.email, password: 'aa', password_confirmation: 'aa')

          expect(page).to have_content 'Password is too short (minimum is 3 characters)'
        end
        
        scenario "Guest can't sign up when password confirmation isn't same with password" do
          sign_up_form_with(email: new_user.email, password: 'secret', password_confirmation: 'another')

          expect(page).to have_content "Password confirmation doesn't match Password"
        end
      end
    end
  end

  feature 'after login' do
    background do
      login_as user
    end

    feature '#root' do
      scenario 'User can access own page' do
        expect(page).to have_link('Mypage', href: user_path(user))
        click_link 'Mypage'
        expect(page).to have_content user.email
      end

      scenario 'User can logout' do
        logout
        expect(page).to have_content 'Logged out'
      end
    end

    feature '#mypage' do
      background do
        visit user_path(user)
      end

      feature 'valid' do
        scenario 'User can access access own profile edit page' do
          expect(page).to have_link('Edit', href: edit_user_path(user))
          click_link 'Edit'

          expect(page).to have_content 'Editing User'
          expect(current_path).to eq edit_user_path(user)
        end
      end
    end

    feature '#edit' do
      given(:update_user) { build :user }

      feature 'valid' do
        scenario 'User can edit own profile with valid email and password' do
          expect{
            edit_form_with(user: user, email: update_user.email, password: 'secret', password_confirmation: 'secret')
          }.to change{User.find(user.id).email}.from(user.email).to(update_user.email)

          expect(page).to have_content('User was successfully updated.')
        end
      end

      feature 'invalid' do
        scenario "User can't edit own profile when they doesn't input email" do
          edit_form_with(user: user, email: nil, password: 'secret', password_confirmation: 'secret')

          expect(page).to have_content("Email can't be blank")
        end

        scenario "User can't edit own profile when email is already exists" do
          edit_form_with(user: user, email: other_user.email, password: 'secret', password_confirmation: 'secret')

          expect(page).to have_content('Email has already been taken')
        end

        scenario "User can't edit own profile when password is shorter than 3 characters" do
          edit_form_with(user: user, email: update_user.email, password: 'aa', password_confirmation: 'aa')

          expect(page).to have_content('Password is too short (minimum is 3 characters)')
        end

        scenario "User can't edit own profile when password confirmation isn't same with password" do
          edit_form_with(user: user, email: update_user.email, password: 'secret', password_confirmation: 'another')

          expect(page).to have_content("Password confirmation doesn't match Password")
        end

        scenario "User can't access another user's profile edit page" do
          visit edit_user_path(other_user)
          expect(page).to have_content 'Forbidden access'
          expect(current_path).not_to eq edit_user_path(other_user)
        end
      end
    end
  end
end

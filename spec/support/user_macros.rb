module UserMacros
  def sign_up_form_with (email:, password:, password_confirmation:)
    visit sign_up_path
    fill_in 'Email', with: email
    fill_in 'Password', with: password
    fill_in 'Password confirmation', with: password_confirmation
    click_button 'SignUp'
  end

  def edit_form_with(user:, email:, password:, password_confirmation:)
    visit edit_user_path(user)
    fill_in 'Email', with: email
    fill_in 'Password', with: password
    fill_in 'Password confirmation', with: password_confirmation
    click_button 'Update'
  end
end

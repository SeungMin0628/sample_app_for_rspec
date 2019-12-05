module LoginMacros
  def login_as(user)
    visit login_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'secret'
    click_button 'Login'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Login successful'
  end

  def try_login(email:, password:)
    visit login_path
    fill_in 'Email', with: email
    fill_in 'Password', with: password
    click_button 'Login'
  end

  def expect_not_auth
    expect(current_path).to eq login_path
    expect(page).to have_content 'Login required'
  end

  def logout
    click_link 'Logout'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Logged out'
  end

  def act_as(user)
    login user
    yield
    logout
  end
end

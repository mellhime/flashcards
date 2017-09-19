module TestHelpers
  module Features
    def login_user(email, password)
      visit login_path

      fill_in 'Email',    with: email
      fill_in 'Password', with: password

      click_button 'Login'
    end
  end
end

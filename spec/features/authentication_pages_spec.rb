require 'rails_helper'

describe "Authentication" do
  let(:user) { create(:user) }
  let(:valid_password) { 'foobar' }

  subject { page }

  describe "login page" do
    before { visit login_path }

    it { should have_content('Login') }
    it { should have_title('Login') }
  end

  describe "signin" do
    before { visit login_path }

    describe "with invalid information" do
      before { click_button "Login" }

      it { should have_title('Login') }
      it { should have_content('Login failed') }

      describe "after visiting another page" do
        before { click_link "Register" }
        it { should_not have_content('Login failed') }
      end
    end

    describe "with valid information" do
      before do
        fill_in "Email",    with: user.email
        fill_in "Password", with: valid_password
        click_button "Login"
      end

      it { should have_title('Все юзеры') }
      it { should have_link('Edit Profile', href: edit_user_path(user)) }
      it { should have_link('Logout', href: logout_path) }
      it { should_not have_link('Login', href: login_path) }

      describe "followed by logout" do
        before { click_link "Logout" }
        it { should have_link('Login') }
      end
    end

    describe "when attempting to visit a protected page" do
      before do
        visit edit_user_path(user)
        fill_in "Email",    with: user.email
        fill_in "Password", with: valid_password
        click_button "Login"
      end

      describe "after login" do
        it "should render the desired protected page" do
          expect(page).to have_title('Редактирование юзера')
        end
      end
    end
  end
end

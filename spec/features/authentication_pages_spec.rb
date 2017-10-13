require 'rails_helper'

describe "Authentication" do
  let(:user) { create(:user) }
  let(:valid_password) { 'foobar' }

  subject { page }

  describe "login page" do
    before { visit login_path }

    it { should have_content('Login') }
    it { should have_title('Login') }
    it { should have_link('Login from Google') }
    it { should have_link('Login from vk') }
  end

  describe "signin" do
    before { visit login_path }

    describe "with invalid information" do
      before { click_button "Login" }

      it { should have_title('Login') }
      it { should have_content('Failed login') }

      describe "after visiting another page" do
        before { click_link "Registration" }
        it { should_not have_content('Failed login') }
      end
    end

    describe "with valid information" do
      before do
        fill_in "email",    with: user.email
        fill_in "password", with: valid_password
        click_button "Login"
      end

      it { should have_title('All users') }
      it { should have_link('Edit profile', href: edit_user_path(user)) }
      it { should have_link('Logout', href: logout_path) }
      it { should have_link('New card', href: new_card_path) }
      it { should have_link('Add pack', href: new_pack_path) }
      it { should have_link('All packs', href: packs_path) }
      it { should_not have_link('Login', href: login_path) }

      describe "followed by logout" do
        before { click_link "Logout" }
        it { should have_link('Login') }
      end
    end

    describe "when attempting to visit a protected page" do
      before do
        visit edit_user_path(user)
      end

      it "should have error message" do
        expect(page).to have_content(I18n.t('layouts.application.notice'))
      end
    end

    describe "when attempting to visit a protected page" do

      before do
        visit edit_user_path(user)
        fill_in "email",    with: user.email
        fill_in "password", with: valid_password
        click_button "Login"
      end

      it "should render the desired protected page" do
        expect(page).to have_title('Edit profile')
      end
    end
  end

  describe "when user not logged in" do
    before do
      visit login_path
      click_link "en"
    end

    it "can change locale" do
      expect(I18n.locale).to eq(:en)
    end
  end
end

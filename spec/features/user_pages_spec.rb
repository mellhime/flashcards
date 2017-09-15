require 'rails_helper'

describe "User pages" do
  subject { page }

  describe "index" do
    before do
      FactoryGirl.create(:user, name: "Bob", email: "bob@example.com")
      FactoryGirl.create(:user, name: "Ben", email: "ben@example.com")
      visit users_path
    end

    it { should have_title('Все юзеры') }
    it { should have_content('Все юзеры') }

    it "should list each user" do
      User.all.each do |user|
        expect(page).to have_selector('li', text: user.name)
      end
    end
  end

  describe "profile page" do
    let(:user) { create(:user) }
    let(:valid_password) { 'foobar' }

    before do
      login_user(user.email, valid_password)
      visit user_path(user)
    end

    it { should have_content(user.name) }
    it { should have_title(user.name) }
  end

  describe "signup page" do
    before { visit new_user_path }

    it { should have_content('Новый пользователь') }
    it { should have_title('Новый пользователь') }
  end

  describe "signup page" do
    before { visit new_user_path }

    let(:submit) { "Create User" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_title('Новый пользователь') }
        it { should have_content('errors') }
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name",         with: "ExampleUser"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Password confirmation", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }

        it { should have_link('Logout') }
        it { should have_title(user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
      end
    end
  end

  describe "edit" do
    let(:user) { create(:user) }
    let(:valid_password) { 'foobar' }
    let(:invalid_password) { 'barfoo' }

    before do
      login_user(user.email, valid_password)
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_content("Редактирование юзера") }
      it { should have_title("Редактирование юзера") }
    end

    describe "with invalid information" do
      before do
        fill_in "Name",         with: "AnotherName"
        fill_in "Email",        with: "another_email@example.com"
        fill_in "Password",     with: valid_password
        fill_in "Password confirmation", with: invalid_password
        click_button "Update User"
      end

      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_name)  { "NewName" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: valid_password
        fill_in "Password confirmation", with: valid_password
        click_button "Update User"
      end

      it { should have_title(new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Logout', href: logout_path) }
      it { expect(user.reload.name).to  eq new_name }
      it { expect(user.reload.email).to eq new_email }
    end
  end
end

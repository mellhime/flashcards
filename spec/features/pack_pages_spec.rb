require 'rails_helper'

describe "Pack pages" do
  subject { page }

  let(:user) { create(:user) }
  let(:pack) { create(:pack, user_id: user.id) }
  let(:valid_password) { 'foobar' }
  after(:all) { User.delete_all }

  describe "index page" do
    before do
      create(:pack, user_id: user.id)
      create(:pack, user_id: user.id)
      login_user(user.email, valid_password)
      visit packs_path
    end

    it { should have_content('Все колоды') }
    it { should have_title('Все колоды') }
    it { should have_link('edit') }
    it { should have_link('show') }
    it { should have_link('delete') }

    it "should list each pack" do
      Pack.all.each do |pack|
        expect(page).to have_selector('td', text: pack.name)
      end
    end
  end

  describe "show page" do
    before do
      login_user(user.email, valid_password)
      visit pack_path(pack)
    end

    it { should have_content(pack.name) }
    it { should have_title(pack.name) }
  end

  describe "new pack page" do
    before do
      login_user(user.email, valid_password)
      visit new_pack_path
    end

    describe "page" do
      it { should have_content("Новая колода") }
      it { should have_title("Новая колода") }
    end

    let(:submit) { "Create Pack" }

    describe "with invalid information" do
      it "should not create a pack" do
        expect { click_button submit }.not_to change(Pack, :count)
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name", with: "Example"
        find(:css, "#current").set(0)
      end

      it "should create a pack" do
        expect { click_button submit }.to change(Pack, :count).by(1)
      end
    end
  end

  describe "edit pack page" do
    before do
      login_user(user.email, valid_password)
      visit edit_pack_path(pack)
    end

    describe "page" do
      it { should have_content("Редактирование") }
      it { should have_title("Редактирование") }
    end

    describe "with invalid information" do
      let(:new_name) { "" }
      let(:new_current) { 0 }
      before do
        fill_in "Name", with: new_name
        find(:css, "#current").set(new_current)
        click_button "Update Pack"
      end

      it { should have_content("error") }
      it { expect(pack.reload.name).to eq pack.name }
      it { expect(user.reload.current_pack).to be_nil }
    end

    describe "with valid information and change the current pack" do
      let(:new_name) { "NewExample" }
      let(:new_current) { 1 }
      before do
        fill_in "Name", with: new_name
        find(:css, "#current").set(new_current)
        click_button "Update Pack"
      end

      it { should have_title(new_name) }
      it { expect(pack.reload.name).to eq new_name }
      it { expect(user.reload.current_pack).to eq(Pack.find_by(name: new_name)) }
    end
  end

  describe "delete links" do
    before do
      create(:pack, user_id: user.id)
      login_user(user.email, valid_password)
      visit packs_path
    end

    it { should have_link('delete') }
    it "should be able to delete pack" do
      expect { click_link('delete', match: :first) }.to change(Pack, :count).by(-1)
    end
  end
end

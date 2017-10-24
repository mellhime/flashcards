require 'rails_helper'

describe "Pack pages" do
  subject { page }

  let(:user) { create(:user) }
  let(:pack) { create(:pack, user_id: user.id) }
  let(:valid_password) { 'foobar' }

  describe "index page" do
    before do
      create(:pack, user_id: user.id)
      create(:pack, user_id: user.id)
      login_user(user.email, valid_password)
      visit dashboard_packs_path
    end

    it { should have_content('All packs') }
    it { should have_title('All packs') }
    it { should have_link('Edit') }
    it { should have_link('Show') }
    it { should have_link('Delete') }

    it "should list each pack" do
      Pack.all.each do |pack|
        expect(page).to have_selector('td', text: pack.name)
      end
    end
  end

  describe "show page" do
    before do
      login_user(user.email, valid_password)
      visit dashboard_pack_path(pack)
    end

    it { should have_content(pack.name) }
    it { should have_title(pack.name) }
  end

  describe "new pack page" do
    before do
      login_user(user.email, valid_password)
      visit new_dashboard_pack_path
    end

    describe "page" do
      it { should have_content("New pack") }
      it { should have_title("New pack") }
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
      visit edit_dashboard_pack_path(pack)
    end

    describe "page" do
      it { should have_content("Edit") }
      it { should have_title("Edit") }
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
      visit dashboard_packs_path
    end

    it { should have_link('Delete') }
    it "should be able to delete pack" do
      expect { click_link('Delete', match: :first) }.to change(Pack, :count).by(-1)
    end
  end
end

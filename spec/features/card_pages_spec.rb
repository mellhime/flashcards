require 'rails_helper'

describe "Card pages" do
  subject { page }

  let(:user) { create(:user) }
  let(:pack) { create(:pack, user_id: user.id) }
  let(:card) { create(:card, user_id: user.id) }
  let(:valid_password) { 'foobar' }

  describe "index page" do
    before do
      create(:card, original_text: "Example", translated_text: "Пример", user_id: user.id)
      create(:card, original_text: "NewExample", translated_text: "НовыйПример", user_id: user.id)
      login_user(user.email, valid_password)
      visit cards_path
    end

    it { should have_content('All cards') }
    it { should have_title('All cards') }
    it { should have_link('Edit') }
    it { should have_link('Show') }
    it { should have_link('Delete') }

    it "should list each card" do
      Card.all.each do |card|
        expect(page).to have_selector('td', text: card.original_text)
      end
    end
  end

  describe "show page" do
    before do
      login_user(user.email, valid_password)
      visit card_path(card)
    end
    it { should have_content(card.original_text) }
    it { should have_title(card.original_text) }
    it { should have_css('img') }
    it { should have_content(card.pack.name) }
  end

  describe "new card page" do
    before do
      login_user(user.email, valid_password)
      visit new_pack_path
      fill_in "Name", with: "Example"
      find(:css, "#current").set(0)
      click_button "Create Pack"
      visit new_card_path
    end

    describe "page" do
      it { should have_link("Create pack") }
      it { should have_field("Image") }
    end

    let(:submit) { "Create Card" }

    describe "with invalid information" do
      it "should not create a card" do
        expect { click_button submit }.not_to change(Card, :count)
      end
    end

    describe "with valid information" do
      before do
        fill_in "card_original_text", with: "Example"
        fill_in "card_translated_text", with: "Пример"
        select "Example", from: "card[pack_id]"
      end

      it "should create a card" do
        expect { click_button submit }.to change(Card, :count).by(1)
      end
    end

    describe "when image uploaded via URL" do
      before do
        fill_in "card_original_text", with: "Example"
        fill_in "card_translated_text", with: "Пример"
        fill_in "card_image_url", with: "https://www.google.ru/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png"
        select "Example", from: "card[pack_id]"
        click_button submit
      end

      it { expect(page).to have_css('img') }
    end

    describe "when image uploaded via file" do
      before do
        fill_in "card_original_text", with: "Example"
        fill_in "card_translated_text", with: "Пример"
        select "Example", from: "card[pack_id]"
        attach_file :card_image, 'spec/support/fixtures/image.jpg'
        click_button submit
      end

      it { expect(page).to have_css('img') }
    end
  end

  describe "edit card page" do
    before do
      login_user(user.email, valid_password)
      visit new_pack_path
      fill_in "Name", with: "Example"
      find(:css, "#current").set(0)
      click_button "Create Pack"
      visit edit_card_path(card)
    end

    describe "page" do
      it { should have_content("Edit") }
      it { should have_title("Edit") }
    end

    describe "with valid information" do
      let(:new_orig_text)  { "NewExample" }
      let(:new_trans_text) { "НовыйПример" }
      before do
        fill_in "card_original_text", with: new_orig_text
        fill_in "card_translated_text", with: new_trans_text
        select "Example", from: "card[pack_id]"
        click_button "Update Card"
      end

      it { should have_title(new_orig_text) }
      it { expect(card.reload.original_text).to eq new_orig_text }
      it { expect(card.reload.translated_text).to eq new_trans_text }
    end

    describe "with invalid information" do
      let(:new_orig_text)  { "NewExample" }
      let(:new_trans_text) { "NewExample" }
      before do
        fill_in "card_original_text", with: new_orig_text
        fill_in "card_translated_text", with: new_trans_text
        select "Example", from: "card[pack_id]"
        click_button "Update Card"
      end

      it { should have_content("errors") }
      it { expect(card.reload.original_text).to eq card.original_text }
      it { expect(card.reload.translated_text).to eq card.translated_text }
    end
  end

  describe "delete links" do
    before do
      create(:card, user_id: user.id)
      login_user(user.email, valid_password)
      visit cards_path
    end

    it { should have_link('Delete') }
    it "should be able to delete card" do
      expect { click_link('Delete', match: :first) }.to change(Card, :count).by(-1)
    end
  end

  describe "check card translation" do
    let(:second_card) { create(:card, user_id: user.id) }

    before do
      card.update_attributes(review_date: Date.today)
      second_card.update_attributes(review_date: Date.today)
      login_user(user.email, valid_password)
      visit root_path
    end

    describe "with valid translation" do
      before do
        fill_in :user_text, with: card.original_text
        find("#seconds", visible: false).set(1)
        click_button "Check"
      end

      it { expect(page).to have_content("You're right!") }
      it { expect(page).to have_content(second_card.translated_text) }
    end

    describe "with invalid translation" do
      before do
        fill_in :user_text, with: "Invalid"
        click_button "Check"
      end

      it { expect(page).to have_content("You're not right!") }
      it { expect(page).to have_content(card.translated_text) }
    end

    describe "when there are no cards to review" do
      before do
        Card.delete_all
        visit root_path
      end

      it { expect(current_path).to eql(cards_path) }
      it { expect(page).to have_content('No cards to review') }
    end
  end

  describe "check card translation from current pack" do
    let(:card_from_pack) { create(:card, translated_text: "другойтекст", user_id: user.id, pack_id: pack.id) }

    before do
      user.update_attributes(current_pack_id: pack.id)
      card.update_attributes(review_date: Date.today)
      card_from_pack.update_attributes(review_date: Date.today)
      login_user(user.email, valid_password)
      visit root_path
    end

    it { expect(page).to have_content(card_from_pack.translated_text) }
    it { expect(page).not_to have_content(card.translated_text) }
  end
end

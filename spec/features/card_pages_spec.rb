require 'rails_helper'

describe "Card pages" do

  subject { page }

  let(:user) { create(:user) }
  let(:valid_password) { 'foobar' }
  after(:all) { User.delete_all }

  describe "index" do
    before do
      create(:card, original_text: "Example", translated_text: "Пример", user_id: user.id)
      create(:card, original_text: "NewExample", translated_text: "НовыйПример", user_id: user.id)
      login_user(user.email, valid_password)
      visit cards_path
    end

    it { should have_content('Все карточки') }
    it { should have_title('Все карточки') }
    it { should have_link('edit') }
    it { should have_link('show') }
    it { should have_link('delete') }

    it "should list each card" do
      Card.all.each do |card|
        expect(page).to have_selector('td', text: card.original_text)
      end
    end
  end

  describe "card page" do
    before do
      login_user(user.email, valid_password)
      visit card_path(card)
    end
    let(:card) { create(:card, user_id: user.id) }
    it { should have_content(card.original_text) }
    it { should have_title(card.original_text) }
    it { should have_css('img') }
  end

  describe "new card page" do
    before do
      login_user(user.email, valid_password)
      visit new_card_path
    end
    let(:submit) { "Create Card" }

    describe "with invalid information" do
      it "should not create a card" do
        expect { click_button submit }.not_to change(Card, :count)
      end
    end

    describe "with valid information" do
      before do
        fill_in "Original text", with: "Example"
        fill_in "Translated text", with: "Пример"
      end

      it "should create a card" do
        expect { click_button submit }.to change(Card, :count).by(1)
      end
    end

    describe "when avatar uploaded via URL" do
      before do
        fill_in "Original text", with: "Example"
        fill_in "Translated text", with: "Пример"
        fill_in "Enter a URL", with: "https://www.google.ru/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png"
        click_button submit
      end

      it { expect(page).to have_css('img') }
    end
  end

  describe "edit card page" do
    let(:card) { create(:card, user_id: user.id) }
    before do
      login_user(user.email, valid_password)
      visit edit_card_path(card)
    end

    describe "page" do
      it { should have_content("Редактирование") }
      it { should have_title("Редактирование") }
    end

    describe "with valid information" do
      let(:new_orig_text)  { "NewExample" }
      let(:new_trans_text) { "НовыйПример" }
      before do
        fill_in "Original text", with: new_orig_text
        fill_in "Translated text", with: new_trans_text
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
        fill_in "Original text", with: new_orig_text
        fill_in "Translated text", with: new_trans_text
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

    it { should have_link('delete') }
    it "should be able to delete card" do
      expect{click_link('delete', match: :first)}.to change(Card, :count).by(-1)
    end
  end

  describe "check card translation" do
    let!(:card) { create(:card, user_id: user.id) }
    let!(:second_card) { create(:card, user_id: user.id) }

    before do
      card.update_attributes(review_date: Date.today)
      second_card.update_attributes(review_date: Date.today)
      login_user(user.email, valid_password)
      visit root_path
    end

    describe "with valid translation" do
      before do
        fill_in :user_text, with: card.original_text
        click_button "Check"
      end

      it { expect(page).to have_content('Правильно!') }
      it { expect(Card.can_be_reviewed.count).to eq(1) }
    end

    describe "with ivalid translation" do
      before do
        fill_in :user_text, with: "Invalid"
        click_button "Check"
      end

      it { expect(page).to have_content('Неправильно!') }
      it { expect(Card.can_be_reviewed.count).to eq(2) }
    end

    describe "when there are no cards to review" do
      before do
        Card.delete_all
        visit root_path
      end

      it { expect(current_path).to eql(cards_path) }
      it { expect(page).to have_content('Нет карточек для проверки!') }
      it { expect(Card.can_be_reviewed.count).to eq(0) }
    end
  end
end

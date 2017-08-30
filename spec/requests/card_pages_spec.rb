require 'spec_helper'
require 'rails_helper'

describe "Card pages" do

  subject { page }

  describe "index" do
    before do
      FactoryGirl.create(:card, original_text: "Example", translated_text: "Пример")
      FactoryGirl.create(:card, original_text: "NewExample", translated_text: "НовыйПример")
      visit cards_path
    end

    it { should have_content('Все карточки') }
    it { should have_title('Все карточки') }

    it "should list each user" do
      Card.all.each do |card|
        expect(page).to have_selector('li', text: card.original_text)
      end
    end

    describe "pagination" do

      before(:all) { 30.times { FactoryGirl.create(:card) } }
      after(:all)  { Card.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each card" do
        Card.paginate(page: 1).each do |card|
          expect(page).to have_selector('li', text: card.original_text)
        end
      end
    end
  end

  describe "card page" do
    before { visit card_path(card) }
    let(:card) { FactoryGirl.create(:card) }
    it { should have_content(card.original_text) }
    it { should have_title(card.original_text) }
  end

  describe "new card page" do

    before { visit new_card_path }

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
  end

  describe "edit card page" do
    let(:card) { FactoryGirl.create(:card) }
    before { visit edit_card_path(card) }

    describe "page" do
      it { should have_content("Редактирование") }
      it { should have_title("Редактирование") }
    end

    describe "with valid information" do
      let(:new_orig_text)  { "New Example" }
      let(:new_trans_text) { "Новый Пример" }
      before do
        fill_in "Original text", with: new_orig_text
        fill_in "Translated text", with: new_trans_text
        click_button "Update Card"
      end

      it { should have_title(new_orig_text) }
      it { expect(card.reload.original_text).to eq new_orig_text }
      it { expect(card.reload.translated_text).to eq new_trans_text }
    end
  end
end

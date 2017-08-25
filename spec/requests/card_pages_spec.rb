require 'spec_helper'
require 'rails_helper'

describe "Card pages" do

  subject { page }

  describe "index" do
    before do
      FactoryGirl.create(:card)
      FactoryGirl.create(:card, original_text: "Example", translated_text: "Пример")
      FactoryGirl.create(:card, original_text: "Example", translated_text: "Пример")
      visit cards_path
    end

    it { should have_content('Все карточки') }
    it { should have_title('Все карточки') }

    it "should list each user" do
      Card.all.each do |card|
        expect(page).to have_selector('li', text: card.original_text)
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

    describe "with invalid information" do
      before { click_button "Update Card" }

      it { should have_content('error') }
    end
  end

end

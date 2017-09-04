require 'rails_helper'

describe Card do

  let(:card) { create(:card) }
  subject { card }

  it { should respond_to(:original_text) }
  it { should respond_to(:translated_text) }
  it { should respond_to(:review_date) }
  it { should be_valid }

  describe "when original_text is not present" do
    before { card.original_text = " " }
    it { should_not be_valid }
  end

  describe "when translated_text is not present" do
    before { card.translated_text = " " }
    it { should_not be_valid }
  end

  describe "when original_text is too long" do
    before { card.original_text = "w" * 36 }
    it { should_not be_valid }
  end

  describe "when original_text format is invalid" do
    it "should be invalid" do
      words = %w[собака дыня арбуз велосипед 457439 *:?(*?)]
      words.each do |invalid_word|
        card.original_text = invalid_word
        expect(card).not_to be_valid
      end
    end
  end

  describe "when translated_text format is valid" do
    it "should be valid" do
      words = %w[foo bar Hair JoJo hkdhfjkdhgjdghdkfdhLJFLDKSHGLDS]
      words.each do |valid_word|
        card.original_text = valid_word
        expect(card).to be_valid
      end
    end
  end

  describe "when translated_text equal to original_text" do 
    before { card.original_text = card.translated_text }
    it { should_not be_valid }
  end

  describe "when review_date have been created" do

    let(:card) { create(:card) }

    it "should be valid" do
      expect(card.review_date).not_to be_nil
    end
    it "should be 3 days from now" do
      expect(card.review_date).to eq(Date.today + 3.days)
    end
  end

  describe "scope can_be_reviewed" do

    let(:card) { create(:card) }

    it "excludes cards that can't be reviewed" do
      card.update_attributes(review_date: Date.today + 2.days)
      Card.can_be_reviewed.should_not include(card)
    end

    it "includes cards that can be reviewed" do
      card.update_attributes(review_date: Date.today - 2.days)
      Card.can_be_reviewed.should include(card)
    end
  end
end

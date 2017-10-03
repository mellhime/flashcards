require 'rails_helper'

describe Card do
  let(:user) { create(:user) }
  let(:card) { create(:card, user_id: user.id) }

  subject { card }

  it { should respond_to(:original_text) }
  it { should respond_to(:translated_text) }
  it { should respond_to(:review_date) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should eq user }
  it { should respond_to(:image) }

  it { should be_valid }

  describe "when original_text is not present" do
    before { card.original_text = " " }
    it { is_expected.not_to be_valid }
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
    its(:review_date) { is_expected.not_to be_nil }
    # its(:review_date) { is_expected.to eq(Date.today + 3.days) }
  end

  describe "scope random_card_to_review" do

    it "excludes cards that can't be reviewed" do
      card.update_attributes(review_date: Date.today + 2.days)
      Card.random_card_to_review.should_not include(card)
    end

    it "includes cards that can be reviewed" do
      card.update_attributes(review_date: Date.today - 2.days)
      Card.random_card_to_review.should include(card)
    end
  end

  describe "when user_id is not present" do
    before { card.user_id = nil }
    it { should_not be_valid }
  end

  describe "when image uploaded via file" do
    before { card.update_attributes(image: File.new("#{Rails.root}/spec/support/fixtures/image.jpg")) }

    its(:image) { is_expected.not_to be_nil }
    its(:image_content_type) { is_expected.to eq("image/jpeg") }
  end

  describe "when image uploaded via URL" do
    let(:valid_url) { "https://www.google.ru/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png" }
    let(:invalid_url) { "htps://www.google.ru/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png" }

    before { card.update_attributes(image: nil) }

    describe "URL is valid" do
      before { card.update_attributes(image_url: valid_url) }

      its(:image_url) { is_expected.not_to be_nil }
      its(:image_url) { is_expected.to be_kind_of(String) }
      its(:image) { is_expected.not_to be_nil }
      its(:image_content_type) { is_expected.to eq("image/png") }
    end

    describe "URL is invalid" do
      before { card.update_attributes(image_url: invalid_url) }

      its(:image_file_name) { is_expected.to be_nil }
      its(:image_file_size) { is_expected.to be_nil }
      its(:image_content_type) { is_expected.to be_nil }

      it 'should add error' do
        expect(card.errors.messages).to include(image_url: ["is not a valid URL"])
      end
    end
  end
end

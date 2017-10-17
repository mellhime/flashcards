require 'rails_helper'

describe CheckCard do
  let(:valid_params) { 'Valid' }
  let(:invalid_params) { 'Invalid' }
  let(:card) { create(:card, original_text: valid_params, review_status: 1) }


  describe "when answer is valid" do
    let(:seconds) { 15 }
    let(:interactor) { CheckCard.call(user_text: valid_params, card: card, seconds: seconds) }

    it "should calculate easiness_factor" do
      expect(interactor.card.easiness_factor).to eq(2.6)
    end

    it "should check card and success if valid and increase review_status" do
      expect(interactor).to be_a_success
      expect(interactor.card.review_status).to eq(2)
    end

    it "should calculate interval and review date" do
      expect(interactor.card.interval).to eq(6)
      expect(interactor.card.review_date.change(:sec => 0)).to eq((Time.current + interactor.card.interval.days).change(:sec => 0))
    end
  end

  describe "when answer isn't valid" do
    let(:seconds) { 99 }
    let(:interactor) { CheckCard.call(user_text: invalid_params, card: card, seconds: seconds) }

    it "easiness_factor should be the same"  do
      expect(interactor.card.easiness_factor).to eq(2.5)
    end

    it "should check card and success if valid and review_status should be 1" do
      expect(interactor).to be_a_failure
      expect(interactor.card.review_status).to eq(1)
    end

    it "its interval should be 1 day" do
      expect(interactor.card.interval).to eq(1)
      expect(interactor.card.review_date.change(:sec => 0)).to eq((Time.current + interactor.card.interval.days).change(:sec => 0))
    end

    it ".call should check card and fail if not valid and detect misprints" do
      interactor = CheckCard.call(user_text: "Valdi", card: card, seconds: seconds)
      expect(interactor.message).to eq("You have misprint: %{user_text}. Word: %{card.original_text} - %{card.translated_text}")
      expect(interactor).to be_a_failure
    end
  end
end

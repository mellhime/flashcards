require 'rails_helper'

describe CheckCard do

  let(:valid_params) { 'Valid' }
  let(:invalid_params) { 'Invalid' }
  let(:card) { create(:card, original_text: valid_params) }

  xit ".call should check card and success if valid" do
    interactor = CheckCard.call(user_text: valid_params, card: card)
    expect(interactor).to be_a_success
    expect(interactor.card.review_date).to eq((Date.today + 3.days))
  end

  xit ".call should check card and fail if not valid" do
    interactor = CheckCard.call(user_text: invalid_params, card: card)
    expect(interactor).to be_a_failure
  end
end

require 'rails_helper'

describe CheckCard do
  before do
    @card = FactoryGirl.create(:card)
  end

  it ".call should check card and success if valid" do
    interactor = CheckCard.call(user_text: "Sun", card: @card)
    expect(interactor).to be_a_success
    expect(interactor.card.review_date).to eq((Date.today + 3.days))
  end

  it ".call should check card and fail if not valid" do
    interactor = CheckCard.call(user_text: "Suh", card: @card)
    expect(interactor).to be_a_failure
  end
end

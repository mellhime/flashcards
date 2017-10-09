require 'rails_helper'
include TestHelpers::Features

describe CheckCard do
  let(:user) { create(:user) }
  let(:valid_params) { 'Valid' }
  let(:invalid_params) { 'Invalid' }
  let(:card) { create(:card, original_text: valid_params) }

  before do
    login_user(user.email, user.password)
    visit root_path
  end

  xit ".call should check card and success if valid and increase check_count" do
    interactor = CheckCard.call(user_text: valid_params, card: card, session: session)
    expect(interactor).to be_a_success
    expect(interactor.card.check_count).to eq(1)
  end

  xit ".call should check card and fail if not valid" do
    interactor = CheckCard.call(user_text: invalid_params, card: card)
    expect(interactor).to be_a_failure
  end
end

require 'rails_helper'

describe CheckCard do
  let(:session) { { fails_count: nil, card_id: nil } }
  let(:valid_params) { 'Valid' }
  let(:invalid_params) { 'Invalid' }
  let(:card) { create(:card, original_text: valid_params) }

  it ".call should check card and success if valid and increase check_count" do
    interactor = CheckCard.call(user_text: valid_params, card: card, session: session)
    expect(interactor).to be_a_success
    expect(interactor.card.check_count).to eq(1)
    expect(interactor.session[:fails_count]).to be_nil
  end

  it ".call should check card and fail if not valid and increase fails count if it's < 3" do
    session[:fails_count] = 2
    interactor = CheckCard.call(user_text: invalid_params, card: card, session: session)
    expect(interactor.session[:card_id]).to eq(interactor.card.id)
    expect(interactor.session[:fails_count]).to eq(3)
    expect(interactor).to be_a_failure
  end

  it ".call should check card and fail if not valid and increase fails count if it's < 3" do
    session[:fails_count] = 3
    interactor = CheckCard.call(user_text: invalid_params, card: card, session: session)
    expect(interactor.session[:fails_count]).to be_nil
    expect(interactor.card.check_count).to eq(0)
    expect(interactor).to be_a_failure
  end

  it ".call should check card and fail if not valid and detect misprints" do
    interactor = CheckCard.call(user_text: "Valdi", card: card, session: session)
    expect(interactor.message).to eq("Вы опечатались: #{interactor.user_text}. Слово: #{interactor.card.original_text} - #{interactor.card.translated_text}")
    expect(interactor).to be_a_failure
  end
end

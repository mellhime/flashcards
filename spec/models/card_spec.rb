require 'rails_helper'

describe Card do

  before do @card = Card.new(original_text: "Example", translated_text: "Пример", review_date: "01.01.2001")
  end

  subject { @card }

  it { should respond_to(:original_text) }
  it { should respond_to(:translated_text) }
  it { should respond_to(:review_date) }
end

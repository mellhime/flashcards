FactoryGirl.define do
  factory :card do
    original_text     "Sun"
    translated_text   "Солнце"
    review_date "01.01.2001"
    avatar { File.new("#{Rails.root}/spec/support/fixtures/image.jpg") }
    user
  end
end

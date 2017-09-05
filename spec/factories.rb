FactoryGirl.define do
  factory :user do
    name "MyString"
    email "MyString"
  end
  factory :card do
    original_text     "Sun"
    translated_text   "Солнце"
    review_date "01.01.2001"
  end
end

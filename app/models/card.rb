class Card < ApplicationRecord
  before_validation :create_review_date, on: :create
  VALID_ORIGINAL_TEXT_REGEX = /[A-Za-z]/
  validates :original_text, presence: true#, length: { maximum: 35 }, format: { with: VALID_ORIGINAL_TEXT_REGEX }
  VALID_TRANSLATED_TEXT_REGEX = /[а-яА-ЯёЁ]/
  validates :translated_text, presence: true#, length: { maximum: 35 }, format: { with: VALID_TRANSLATED_TEXT_REGEX }
  validate :equality_of_original_and_translated_texts
  validates :review_date, presence: true

  def create_review_date
    self.review_date = Time.now + 259200
  end

  def equality_of_original_and_translated_texts
    errors.add(:translated_text, "can't be the same as original") if original_text.downcase == translated_text.downcase
  end
end

class Card < ApplicationRecord
  belongs_to :user
  belongs_to :pack
  before_validation :create_review_date, on: :create
  before_save :download_remote_image, if: :image_url_provided?

  VALID_ORIGINAL_TEXT_REGEX = /\A[A-z]+\z/
  validates :original_text, presence: true, length: { maximum: 35 }, format: { with: VALID_ORIGINAL_TEXT_REGEX }
  VALID_TRANSLATED_TEXT_REGEX = /\A[\u0400-\u04FF]*\z/
  validates :translated_text, presence: true, length: { maximum: 35 }, format: { with: VALID_TRANSLATED_TEXT_REGEX }
  validate :equality_of_original_and_translated_texts
  validates :review_date, presence: true
  scope :can_be_reviewed, -> { where('DATE(review_date) <= ?', Date.today) }

  has_attached_file :image, styles: { thumb: ["360x360>", :jpeg] }
  validates_attachment :image, content_type: { content_type: %r{\Aimage\/.*\z} }
  validates :image_url, url: { allow_blank: true }

  def create_review_date
    self.review_date = Date.today + 3.days
  end

  def equality_of_original_and_translated_texts
    errors.add(:translated_text, "can't be the same as original") if original_text.downcase == translated_text.downcase
  end

  def image_url_provided?
    !image_url.blank?
  end

  def download_remote_image
    self.image = URI.parse(image_url).to_s
  end
end

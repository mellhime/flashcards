class Card < ApplicationRecord
  belongs_to :user
  belongs_to :pack
  before_save :download_remote_image, if: :image_url_provided?
  before_save :add_review_date

  VALID_ORIGINAL_TEXT_REGEX = /\A[A-z]+\z/
  validates :original_text, presence: true, length: { maximum: 35 }, format: { with: VALID_ORIGINAL_TEXT_REGEX }
  VALID_TRANSLATED_TEXT_REGEX = /\A[\u0400-\u04FF]*\z/
  validates :translated_text, presence: true, length: { maximum: 35 }, format: { with: VALID_TRANSLATED_TEXT_REGEX }
  validate :equality_of_original_and_translated_texts
  validates :review_date, presence: true
  scope :random_card_to_review, -> { where('DATE(review_date) <= ?', Date.today).order("RANDOM()") }

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

  def add_review_date
    self.review_date = Time.current + case self.check_count
                                      when 1
                                        12.hours
                                      when 2
                                        3.days
                                      when 3
                                        7.days
                                      when 4
                                        14.days
                                      when 5
                                        30.days
                                      when 0
                                        1.hours
                                      end
  end
end

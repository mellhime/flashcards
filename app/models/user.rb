class User < ApplicationRecord
  has_many :cards, dependent: :destroy
  has_many :packs, dependent: :destroy
  has_many :authentications, dependent: :destroy
  belongs_to :current_pack, class_name: 'Pack', optional: true

  authenticates_with_sorcery! do |config|
    config.authentications_class = Authentication
  end

  accepts_nested_attributes_for :authentications

  before_save { email.downcase! }
  validates :name, presence: true, length: { maximum: 30 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  scope :has_unreviewed_cards, -> { joins(:cards).where('cards.review_date <= ?', Date.today).uniq }

  def self.random_card(current_user)
    scope = current_user.current_pack.nil? ? current_user : current_user.current_pack
    scope.cards.random_card_to_review.first
  end
end

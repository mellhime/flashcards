class Pack < ApplicationRecord
  has_many :cards, dependent: :destroy
  belongs_to :user
  validates :name, presence: true, length: { maximum: 35 }
end

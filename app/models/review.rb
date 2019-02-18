class Review < ApplicationRecord
  belongs_to :user
  belongs_to :prot
  has_many :comments, dependent: :destroy

  validates :title, presence: true, length: { maximum: 255 }
  validates :content, presence: true
end

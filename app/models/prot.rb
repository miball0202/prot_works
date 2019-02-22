class Prot < ApplicationRecord
  belongs_to :user
  has_many :nodes, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :hearts, dependent: :destroy

  has_many :prot_genres, dependent: :destroy
  has_many :genres, through: :prot_genres

  has_many :prot_media_types, dependent: :destroy
  has_many :media_types, through: :prot_media_types

  validates :title, presence: true, length: { maximum: 255 }
  validates :private, inclusion: {in: [true, false]}
  validates :accepts_review, inclusion: {in: [true, false]}
end

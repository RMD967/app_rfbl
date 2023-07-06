class Dashboard < ApplicationRecord
  belongs_to :user
  has_many_attached :images
  has_many_attached :videos
  has_many_attached :audios
  has_many :artist_instruments
  accepts_nested_attributes_for :artist_instruments
  has_one_attached :avatar

  has_many :user_dashboards, dependent: :destroy
  has_many :users, through: :user_dashboards

  validates :artist_genre, presence: true
  validates :artist_count, presence: true
  validates :artist_name, presence: true
  # validates :artist_instrument, presence: true
  validates :artist_location, presence: true
  # validates :artist_radius, presence: true
  # validates :artist_cities, presence: true
  validates :artist_description, presence: true
  validates :artist_price, presence: true
  validates :artist_count, numericality: { only_integer: true }
end

class Event < ApplicationRecord
  GENRE = %w[Rock Pop Urban DJ Ballads Tropical Regional Country Instrumental Choir Jazz Classical Electronic].freeze
  has_one_attached :image
  has_many :bookings
  has_many :users, through: :bookings, source: :user
  has_many :favorites, as: :favoritable, dependent: :destroy
  belongs_to :user
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?

  validates :title, presence: true
  validates :description, presence: true
  validates :datetime, presence: true
  validates :duration, presence: true, numericality: { greater_than: 29 }
  validates :genre, presence: true, inclusion: { in: GENRE }
  validates :address, presence: true
end

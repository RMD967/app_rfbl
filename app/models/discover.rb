class Discover < ApplicationRecord
  has_one_attached :video
  belongs_to :dashboard, foreign_key: "dashboard_id"
  validates :content, :title, presence: true
  validates :genre, presence: true, inclusion: { in: %w[Rock Pop Urban DJ Ballads Tropical Regional Country Instrumental Choir] }
end

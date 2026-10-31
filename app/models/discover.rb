class Discover < ApplicationRecord
  has_one_attached :video
  belongs_to :dashboard, foreign_key: "dashboard_id"
  has_many :comments, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy

  validates :content, :title, presence: true
  validates :genre, presence: true, inclusion: { in: Event::GENRE }

  def liked_by?(user)
    return false unless user
    likes.exists?(user: user)
  end

  def total_likes_count
    (likes.count) + (self[:likes] || 0)
  end
end

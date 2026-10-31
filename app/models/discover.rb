class Discover < ApplicationRecord
  has_one_attached :video
  belongs_to :dashboard, foreign_key: "dashboard_id"
  has_many :comments, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy

  POST_TYPES = %w[music general].freeze

  validates :title, presence: true
  validates :genre, presence: true
  validates :post_type, inclusion: { in: POST_TYPES }, allow_blank: true
  validate :must_have_content_or_video

  scope :music, -> { where(post_type: ["music", nil]) }
  scope :general, -> { where(post_type: "general") }

  def must_have_content_or_video
    if content.blank? && !video.attached?
      errors.add(:base, "Debes ingresar un enlace de video (YouTube o URL) o subir un archivo de video")
    end
  end

  def music?
    post_type.nil? || post_type == "music"
  end

  def general?
    post_type == "general"
  end

  def liked_by?(user)
    return false unless user
    likes.exists?(user: user)
  end

  def total_likes_count
    (likes.count) + (self[:likes] || 0)
  end
end

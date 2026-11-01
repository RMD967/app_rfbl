class Discover < ApplicationRecord
  has_one_attached :video
  belongs_to :dashboard, foreign_key: "dashboard_id"
  has_many :comments, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :video_plays, dependent: :destroy

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
    likes.count
  end

  # Real play count (strictly unique plays where viewer watched > 5 seconds)
  def unique_plays_count
    video_plays.count
  end

  def youtube_id
    return nil if content.blank?
    if content =~ /(?:youtube\.com\/(?:[^\/]+\/.+\/|(?:v|e(?:mbed)?)\/|.*[?&]v=)|youtu\.be\/)([^"&?\/\s]{11})/
      $1
    elsif content.start_with?("yt:")
      content.sub("yt:", "")
    elsif content =~ /^[a-zA-Z0-9_-]{11}$/
      content
    end
  end

  def youtube?
    youtube_id.present?
  end

  def raw_video_source
    if video.attached?
      url = Rails.application.routes.url_helpers.url_for(video)
      url.include?("cloudinary.com") && url.include?("/upload/") && !url.include?("q_auto") ? url.gsub("/upload/", "/upload/q_auto,vc_h264/") : url
    else
      content.presence || "/main.mp4"
    end
  end
end

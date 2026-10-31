class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :discover
  belongs_to :parent, class_name: "Comment", optional: true
  has_many :replies, class_name: "Comment", foreign_key: :parent_id, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy

  validates :content, presence: true

  scope :top_level, -> { where(parent_id: nil) }

  def liked_by?(user)
    return false unless user
    likes.exists?(user: user)
  end
end

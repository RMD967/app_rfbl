class Follow < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  validates :follower_id, uniqueness: { scope: :followed_id, message: "is already following this artist" }
  validate :cannot_follow_self

  private

  def cannot_follow_self
    errors.add(:base, "You cannot follow yourself") if follower_id == followed_id
  end
end

class Notification < ApplicationRecord
  belongs_to :recipient, class_name: "User"
  belongs_to :actor, class_name: "User", optional: true
  belongs_to :notifiable, polymorphic: true, optional: true

  ACTION_TYPES = %w[new_post new_message new_follower new_comment new_like booking_status event_update].freeze

  validates :action_type, presence: true

  scope :unread, -> { where(read_at: nil) }
  scope :read, -> { where.not(read_at: nil) }
  scope :recent, -> { order(created_at: :desc) }

  scope :for_category, ->(category) {
    case category.to_s
    when "following", "posts"
      where(action_type: "new_post")
    when "messages"
      where(action_type: "new_message")
    when "interactions"
      where(action_type: %w[new_comment new_like new_follower])
    when "bookings", "events"
      where(action_type: %w[booking_status event_update])
    else
      all
    end
  }

  def unread?
    read_at.nil?
  end

  def read?
    read_at.present?
  end

  def mark_as_read!
    update(read_at: Time.current) if unread?
  end
end

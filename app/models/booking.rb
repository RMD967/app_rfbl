class Booking < ApplicationRecord
  belongs_to :event
  belongs_to :user
  validates :date, presence: true
  validate :validate_unique_booking_for_user

  def validate_unique_booking_for_user
    if user.bookings.exists?(event_id: event_id)
      errors.add(:base, "You already have a booking for this event.")
    end
  end
end

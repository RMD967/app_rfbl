class VideoPlay < ApplicationRecord
  belongs_to :discover
  belongs_to :user, optional: true

  # Only plays with at least 5 seconds watched count
  validates :duration, numericality: { greater_than_or_equal_to: 5.0, message: "debe ser de al menos 5 segundos para contar como reproducción" }

  # Only one play per registered user per discover
  validates :discover_id, uniqueness: { scope: :user_id, message: "ya cuenta con una reproducción de este usuario" }, if: -> { user_id.present? }

  # Only one play per guest IP per discover
  validates :discover_id, uniqueness: { scope: :ip_address, message: "ya cuenta con una reproducción de esta dirección" }, if: -> { user_id.blank? && ip_address.present? }
end

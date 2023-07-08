class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_one_attached :profile_picture
  has_one :discover
  has_many :user_dashboards, dependent: :destroy
  has_many :bookings
  has_many :events, through: :bookings
  has_many :messages
  has_many :received_messages, class_name: 'Message', foreign_key: 'recipient_id'
  has_many :chat_users
  has_many :chatrooms, through: :chat_users
  has_many :dashboards, through: :user_dashboards
  has_many :admin_dashboards, class_name: "Dashboard", foreign_key: "admin_id"
  has_many :created_events, class_name: 'Event', foreign_key: 'user_id'
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def likes
    self.discover.likes
  end

  def applied_to?(event)
    bookings.where(event: event).exists?
  end

  def admin_of_dashboard?(dashboard)
    self.admin && self.admin_dashboards.include?(dashboard)
  end
end

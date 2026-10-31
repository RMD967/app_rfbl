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

  # Follow associations
  has_many :active_follows, class_name: "Follow", foreign_key: "follower_id", dependent: :destroy
  has_many :following, through: :active_follows, source: :followed

  has_many :passive_follows, class_name: "Follow", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :passive_follows, source: :follower

  # Favorites
  has_many :favorites, dependent: :destroy
  has_many :favorite_events, through: :favorites, source: :favoritable, source_type: 'Event'
  has_many :favorite_dashboards, through: :favorites, source: :favoritable, source_type: 'Dashboard'

  # Social / Comments & Likes
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def favorited?(favoritable)
    favorites.exists?(favoritable: favoritable)
  end

  def favorite(favoritable)
    favorites.find_or_create_by(favoritable: favoritable)
  end

  def unfavorite(favoritable)
    favorites.find_by(favoritable: favoritable)&.destroy
  end

  def likes?(likeable)
    likes.exists?(likeable: likeable)
  end

  def like(likeable)
    likes.find_or_create_by(likeable: likeable)
  end

  def unlike(likeable)
    likes.find_by(likeable: likeable)&.destroy
  end

  def follow(other_user)
    following << other_user unless following?(other_user) || other_user == self
  end

  def unfollow(other_user)
    following.delete(other_user)
  end

  def following?(other_user)
    following.include?(other_user)
  end

  def applied_to?(event)
    bookings.where(event: event).exists?
  end

  def admin_of_dashboard?(dashboard)
    self.admin && self.admin_dashboards.include?(dashboard)
  end

  def full_name
    "#{first_name} #{last_name}".strip.presence || email.split('@').first.capitalize
  end

  def artist_dashboard
    dashboards.first || Dashboard.find_by(user_id: id)
  end
end

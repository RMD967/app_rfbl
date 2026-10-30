class Chatroom < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_many :chat_users, dependent: :destroy
  has_many :users, through: :chat_users

  def other_user(current_user)
    users.where.not(id: current_user.id).first || users.first || current_user
  end

  def last_message
    messages.order(created_at: :asc).last
  end
end

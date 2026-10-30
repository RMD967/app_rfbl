class ChatroomPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      user.chatrooms
    end
  end

  def index?
    true
  end

  def show?
    record.users.include?(user)
  end

  def create?
    true
  end

  def destroy?
    record.users.include?(user)
  end
end

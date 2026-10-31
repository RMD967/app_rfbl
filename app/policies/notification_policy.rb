class NotificationPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(recipient: user)
    end
  end

  def show?
    record.recipient == user
  end

  def update?
    record.recipient == user
  end

  def mark_as_read?
    record.recipient == user
  end

  def mark_all_read?
    true
  end

  def destroy?
    record.recipient == user
  end
end

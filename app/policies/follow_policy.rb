class FollowPolicy < ApplicationPolicy
  def create?
    user.present? && record != user
  end

  def destroy?
    user.present? && record != user
  end
end

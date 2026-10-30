class FavoritePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      user.favorites
    end
  end

  def index?
    true
  end

  def create?
    user.present?
  end

  def destroy?
    user.present? && record.user == user
  end
end

class CommentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    user.present?
  end

  def destroy?
    user.present? && (record.user == user || (user.respond_to?(:admin?) && user.admin?))
  end
end

class MessagePolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.where(recipient_id: user)
    end
  end

  def create?
    # Define the authorization rules for the create action here
    true
  end
end

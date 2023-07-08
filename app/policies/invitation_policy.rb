class InvitationPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def new?
    user.admin_of_dashboard?(record.dashboard) # Only admins can create invitations
  end

  def create?
    user.admin? # Only admins can create invitations
  end
end

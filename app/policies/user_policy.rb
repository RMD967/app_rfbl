class UserPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def update_profile_picture?
    user == record # Only allow users to update their own profile picture
  end

  def delete_profile_picture?
    # Only allow users to delete their own profile picture
    user == record
  end

  def edit_password?
    user == record # Only allow users to edit their own password
  end

  def update_password?
    user == record
  end
end

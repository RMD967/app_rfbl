class InvitationsController < ApplicationController
  def new
    @invitation = Invitation.new
    @dashboard = Dashboard.find(params[:dashboard_id])
    authorize @dashboard, :new?
  end

  def create
    @dashboard = Dashboard.find(params[:dashboard_id])

    if params[:invitation].present? && params[:invitation][:email].present?
      email = params[:invitation][:email]
      user = User.find_by(email: email)

      if user.nil?
        flash[:error] = "User with the provided email does not exist. Please ask them to register first."
      elsif @dashboard.users.include?(user)
        flash[:error] = "User is already a member of the dashboard."
      else
        @dashboard.users << user
        flash[:success] = "User successfully invited!"
        # Handle any additional logic, such as sending a notification email or updating dashboard statistics
      end
    else
      flash[:error] = "Invalid input. Please try again."
    end

    redirect_to dashboard_path(@dashboard, invitation_success: flash[:success], invitation_error: flash[:error])
  end

  private

  def invitation_params
    params.require(:invitation).permit(:email, :dashboard_id)
  end
end

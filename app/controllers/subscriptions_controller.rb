class SubscriptionsController < ApplicationController
  def create
    # Get the email and user ID from the form data
    email = params[:email]
    user_id = params[:user_id]
    # Create a new Subscription record
    @subscription = Subscription.create(email: email, user_id: user_id)
    # Authorize the subscription
    authorize @subscription
    # Redirect to a success page
    redirect_to root_path
  end

  private

  def subscription_params
    params.require(:subscription).permit(:email, :user_id)
  end
end

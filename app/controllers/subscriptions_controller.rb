class SubscriptionsController < ApplicationController
  def create
    email = params[:email] || params.dig(:subscription, :email)
    user_id = params[:user_id] || params.dig(:subscription, :user_id) || current_user&.id

    @subscription = Subscription.new(email: email, user_id: user_id)
    authorize @subscription

    if @subscription.save
      redirect_back fallback_location: root_path, notice: t('footer.subscribed_success', default: "Thank you for subscribing to our digest!")
    else
      redirect_back fallback_location: root_path, alert: @subscription.errors.full_messages.to_sentence
    end
  end

  private

  def subscription_params
    params.require(:subscription).permit(:email, :user_id)
  end
end

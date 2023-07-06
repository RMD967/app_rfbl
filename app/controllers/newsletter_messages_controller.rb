class NewsletterMessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!

  def edit
    @newsletter_message = NewsletterMessage.last
  end

  def update
    @newsletter_message = NewsletterMessage.last
    @newsletter_message.update(newsletter_message_params)
    redirect_to root_path, notice: "Newsletter message updated"
  end

  private

  def newsletter_message_params
    params.require(:newsletter_message).permit(:subject, :content)
  end

  def authorize_admin!
    redirect_to root_path, alert: "Not authorized" unless current_user.admin?
  end
end

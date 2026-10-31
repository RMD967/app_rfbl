class NotificationsController < ApplicationController
  before_action :authenticate_user!
  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped

  def mark_as_read
    @notification = current_user.received_notifications.find(params[:id])
    @notification.mark_as_read!

    respond_to do |format|
      format.json { render json: { status: "success", unread_count: current_user.unread_notifications_count } }
      format.html { redirect_back(fallback_location: activity_path) }
    end
  end

  def mark_all_read
    current_user.received_notifications.unread.update_all(read_at: Time.current)

    respond_to do |format|
      format.json { render json: { status: "success", unread_count: 0 } }
      format.html { redirect_to activity_path, notice: "Todas las notificaciones fueron marcadas como leídas." }
    end
  end

  def destroy
    @notification = current_user.received_notifications.find(params[:id])
    @notification.destroy

    respond_to do |format|
      format.json { render json: { status: "deleted" } }
      format.html { redirect_to activity_path, notice: "Notificación eliminada." }
    end
  end
end

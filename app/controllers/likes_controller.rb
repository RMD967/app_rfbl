class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_likeable

  def create
    authorize Like
    current_user.like(@likeable)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back(fallback_location: discovers_path) }
    end
  end

  def destroy
    authorize Like
    current_user.unlike(@likeable)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back(fallback_location: discovers_path) }
    end
  end

  private

  def set_likeable
    if params[:likeable_type].present? && params[:likeable_id].present?
      klass = params[:likeable_type].constantize
      raise Pundit::NotAuthorizedError unless [Discover, Comment].include?(klass)
      @likeable = klass.find(params[:likeable_id])
    elsif params[:id].present?
      like = current_user.likes.find(params[:id])
      @likeable = like.likeable
    end
  end
end

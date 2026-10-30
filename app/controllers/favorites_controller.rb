class FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_favoritable, only: [:create, :destroy]

  def index
    @favorites = policy_scope(Favorite).includes(:favoritable).order(created_at: :desc)
    authorize Favorite
    @favorite_events = current_user.favorite_events
    @favorite_dashboards = current_user.favorite_dashboards
  end

  def create
    authorize Favorite
    current_user.favorite(@favoritable)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back(fallback_location: favorites_path) }
    end
  end

  def destroy
    @favorite = current_user.favorites.find_by(favoritable: @favoritable)
    authorize (@favorite || Favorite.new(user: current_user))
    current_user.unfavorite(@favoritable)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back(fallback_location: favorites_path) }
    end
  end

  private

  def set_favoritable
    if params[:favoritable_type].present? && params[:favoritable_id].present?
      @favoritable = params[:favoritable_type].constantize.find(params[:favoritable_id])
    elsif params[:id].present?
      favorite = current_user.favorites.find(params[:id])
      @favoritable = favorite.favoritable
    end
  end
end

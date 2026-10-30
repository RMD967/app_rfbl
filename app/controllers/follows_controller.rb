class FollowsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_artist

  def create
    authorize @artist, policy_class: FollowPolicy
    current_user.follow(@artist)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back(fallback_location: root_path) }
    end
  end

  def destroy
    authorize @artist, policy_class: FollowPolicy
    current_user.unfollow(@artist)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back(fallback_location: root_path) }
    end
  end

  private

  def set_artist
    @artist = User.find(params[:user_id])
  end
end

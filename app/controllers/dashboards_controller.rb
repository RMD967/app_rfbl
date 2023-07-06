class DashboardsController < ApplicationController
  before_action :set_event, only: %i[show edit update destroy]

  def index
    @dashboards = policy_scope(Dashboard)
    @dashboards = Dashboard.joins(:user_dashboards).where(user_dashboards: { user_id: current_user.id })
  end

  def show
    skip_authorization
    @dashboard = Dashboard.find(params[:id])
    @users = @dashboard.users
  end

  def new
    @dashboard = Dashboard.new
    authorize @dashboard
    @artist_travel_value = @dashboard.artist_travel
  end

  # GET /dashboards/1/edit
  def edit
    @dashboard = Dashboard.find(params[:id])
    authorize @dashboard
  end

  # POST /dashboards
  def create
    @dashboard = Dashboard.new(dashboard_params)
    @dashboard.user = current_user
    authorize @dashboard

    if @dashboard.save!
      UserDashboard.create(user: current_user, dashboard: @dashboard)
      redirect_to @dashboard, notice: "Dashboard was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /events/1
  def update
    authorize @dashboard

    existing_audios = @dashboard.audios.attachments
    existing_videos = @dashboard.videos.attachments
    existing_images = @dashboard.images.attachments

    if @dashboard.update(dashboard_params)
      # Append the newly uploaded files to the existing attachments
      @dashboard.audios.attach(existing_audios) if existing_audios.present?
      @dashboard.videos.attach(existing_videos) if existing_videos.present?
      @dashboard.images.attach(existing_images) if existing_images.present?
      redirect_to @dashboard, notice: "Dashboard was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /dashboards/1
  def destroy
    @dashboard.destroy
    authorize @dashboard
    redirect_to dashboards_url, notice: "Dashboard was successfully destroyed.", status: :see_other
  end

  def audio
    # Load the audio content from your model or database
    @audio_content = Dashboard.find(params[:id]).audio_content

    # Render the audio content as HTML
    render html: @audio_content
  end

  def video
    # Load the video content from your model or database
    @video_content = Dashboard.find(params[:id]).video_content

    # Render the video content as HTML
    render html: @video_content
  end

  def images
    # Load the images content from your model or database
    @images_content = Dashboard.find(params[:id]).images_content

    # Render the images content as HTML
    render html: @images_content
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @dashboard = Dashboard.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def dashboard_params
    params.require(:dashboard).permit(:avatar, :artist_genre, :artist_count, :artist_name, :artist_instrument, :artist_location, :artist_travel, :artist_radius, :artist_cities, :artist_description, :artist_price, :avatar, images: [], videos: [], audios: [])
  end
end

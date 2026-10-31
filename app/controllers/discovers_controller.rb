class DiscoversController < ApplicationController
  before_action :set_discover, only: %i[show edit destroy]

  def index
    @current_tab = params[:tab].presence || "for_you"
    @available_locations = ["Puebla", "New York", "Miami", "San Francisco", "Los Angeles", "Chicago", "Austin", "Nashville", "Atlanta"]
    @selected_location = params[:location].presence || "Puebla"

    base_scope = policy_scope(Discover).includes(
      :likes,
      comments: [:user, :likes, { replies: [:user, :likes] }],
      dashboard: [:user, { avatar_attachment: :blob }]
    )

    if @current_tab == "nearby"
      matching_dashboards = Dashboard.where("artist_location ILIKE :loc OR artist_cities ILIKE :loc", loc: "%#{@selected_location}%")
      @discovers = base_scope.where(dashboard: matching_dashboards).order(created_at: :desc)
    else
      @discovers = base_scope.order(created_at: :desc)
    end
  end

  def show
    authorize @discover
  end

  def new
    @discover = Discover.new
    authorize @discover
  end

  def create
    @discover = Discover.new(discover_params)
    @discover.user = current_user if @discover.respond_to?(:user=)
    authorize @discover

    if @discover.save
      redirect_back fallback_location: dashboard_path(@discover.dashboard), notice: "Publicación creada con éxito (#{@discover.music? ? 'Música' : 'Publicación General'})."
    else
      redirect_back fallback_location: discovers_path, alert: @discover.errors.full_messages.join(", ")
    end
  end

  def destroy
    dashboard = @discover.dashboard
    @discover.destroy
    authorize @discover
    redirect_back fallback_location: dashboard_path(dashboard), notice: "Contenido eliminado con éxito.", status: :see_other
  end

  private

  def set_discover
    @discover = Discover.find(params[:id])
  end

  def discover_params
    params.require(:discover).permit(:content, :likes, :plays, :saved, :start_time, :end_time, :dashboard_id, :title, :genre, :post_type, :video)
  end
end

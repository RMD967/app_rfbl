class DiscoversController < ApplicationController
  before_action :set_discover, only: %i[show edit destroy]

  def index
    @current_tab = params[:tab].presence || "for_you"
    @current_genre = params[:genre].to_s.strip
    @current_genre = "Tropical" if @current_tab == "genre" && @current_genre.blank?

    # Dynamic location recommendations from DB + default major hubs
    db_locations = Dashboard.where.not(artist_location: [nil, ""]).pluck(:artist_location)
    @available_locations = (["Puebla", "New York", "Miami", "San Francisco", "Los Angeles", "Chicago", "Austin", "Nashville", "Atlanta"] + db_locations).map(&:strip).uniq

    # Dynamic artist and genre recommendations
    @recommended_artists = Dashboard.where.not(artist_name: [nil, ""]).order(:artist_name).pluck(:artist_name, :artist_genre).uniq { |a| a[0] }
    @recommended_genres = ["Tropical", "Cumbia", "Jazz", "Rock", "Electrónica", "Mariachi", "DJ", "Pop", "Salsa", "Acústico", "Instrumental"]

    # All available genres for "Escucha por género" tab
    db_discover_genres = Discover.where.not(genre: [nil, ""]).pluck(:genre)
    db_artist_genres = Dashboard.where.not(artist_genre: [nil, ""]).pluck(:artist_genre)
    predefined_genres = ["Tropical", "Rock", "Pop", "Urban", "DJ", "Ballads", "Regional", "Cumbia", "Jazz", "Electrónica", "Country", "Instrumental", "Choir", "Salsa"]
    raw_genres = (predefined_genres + db_discover_genres + db_artist_genres).map(&:strip).reject(&:blank?).uniq
    @available_genres = raw_genres.sort_by { |g| g.downcase == "tropical" ? "00_tropical" : g.downcase }

    @query = params[:query].to_s.strip

    base_scope = policy_scope(Discover).includes(
      :likes,
      comments: [:user, :likes, { replies: [:user, :likes] }],
      dashboard: [:user, { avatar_attachment: :blob }]
    )

    if @current_tab == "nearby"
      @search_location = params[:location].presence || params[:location_query].presence || "Puebla"
      matching_dashboards = Dashboard.where("artist_location ILIKE :loc OR artist_cities ILIKE :loc", loc: "%#{@search_location}%")
      @discovers = base_scope.where(dashboard: matching_dashboards).order(created_at: :desc)
    elsif @current_tab == "genre"
      if @current_genre.present? && !["All", "Todos", "all", "todos"].include?(@current_genre)
        matching_dashboards = Dashboard.where("artist_genre ILIKE :g", g: "%#{@current_genre}%")
        @discovers = base_scope.where(
          "discovers.genre ILIKE :g OR discovers.dashboard_id IN (:dash_ids)",
          g: "%#{@current_genre}%",
          dash_ids: matching_dashboards.select(:id)
        ).order(created_at: :desc)
      else
        @discovers = base_scope.order(created_at: :desc)
      end
    else
      if @query.present?
        matching_dashboards = Dashboard.where("artist_name ILIKE :q OR artist_genre ILIKE :q OR artist_instrument ILIKE :q", q: "%#{@query}%")
        @discovers = base_scope.where(
          "discovers.title ILIKE :q OR discovers.genre ILIKE :q OR discovers.dashboard_id IN (:dash_ids)",
          q: "%#{@query}%",
          dash_ids: matching_dashboards.select(:id)
        ).order(created_at: :desc)
      else
        @discovers = base_scope.order(created_at: :desc)
      end
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

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
      scope = base_scope.where(dashboard: matching_dashboards)
      if params[:refresh].present?
        @discovers = scope.order(Arel.sql("RANDOM()")).limit(40)
      else
        @discovers = scope.order(created_at: :desc).limit(40)
      end
    elsif @current_tab == "genre"
      if @current_genre.present? && !["All", "Todos", "all", "todos"].include?(@current_genre)
        matching_dashboards = Dashboard.where("artist_genre ILIKE :g", g: "%#{@current_genre}%")
        scope = base_scope.where(
          "discovers.genre ILIKE :g OR discovers.dashboard_id IN (:dash_ids)",
          g: "%#{@current_genre}%",
          dash_ids: matching_dashboards.select(:id)
        )
        if params[:refresh].present?
          @discovers = scope.order(Arel.sql("RANDOM()")).limit(40)
        else
          @discovers = scope.order(created_at: :desc).limit(40)
        end
      else
        if params[:refresh].present?
          @discovers = base_scope.order(Arel.sql("RANDOM()")).limit(40)
        else
          @discovers = base_scope.order(created_at: :desc).limit(40)
        end
      end
    else
      if @query.present?
        matching_dashboards = Dashboard.where("artist_name ILIKE :q OR artist_genre ILIKE :q OR artist_instrument ILIKE :q", q: "%#{@query}%")
        @discovers = base_scope.where(
          "discovers.title ILIKE :q OR discovers.genre ILIKE :q OR discovers.dashboard_id IN (:dash_ids)",
          q: "%#{@query}%",
          dash_ids: matching_dashboards.select(:id)
        ).order(created_at: :desc).limit(40)
      else
        # Smart personalized recommendation algorithm for "For You"
        @discovers = fetch_for_you_recommendations(base_scope)
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

  def fetch_for_you_recommendations(base_scope)
    # Pull a candidate pool (up to 160 items)
    candidates = base_scope.order(created_at: :desc).limit(160).to_a

    if current_user
      # 1. Behavior affinity: genres user has liked and commented on
      user_liked_ids = current_user.likes.where(likeable_type: "Discover").pluck(:likeable_id).to_set
      liked_genres = Discover.where(id: user_liked_ids.to_a).where.not(genre: [nil, ""]).pluck(:genre)
      commented_genres = Discover.where(id: current_user.comments.pluck(:discover_id)).where.not(genre: [nil, ""]).pluck(:genre)

      affinity_counts = (liked_genres + commented_genres).each_with_object(Hash.new(0)) { |g, h| h[g.downcase] += 1 }
      top_genres = affinity_counts.sort_by { |_, count| -count }.map(&:first)

      # 2. Artists the user follows
      followed_artist_ids = current_user.following.pluck(:id).to_set rescue Set.new
      followed_dashboards = Dashboard.where(user_id: followed_artist_ids.to_a).pluck(:id).to_set

      # 3. Score each candidate
      scored = candidates.map do |disc|
        score = 0
        g = disc.genre.to_s.strip.downcase

        # A. Followed artists prioritized
        score += 50 if followed_dashboards.include?(disc.dashboard_id)

        # B. User taste genre match
        if top_genres[0..1].include?(g)
          score += 35
        elsif top_genres[2..4].include?(g)
          score += 20
        elsif top_genres.include?(g)
          score += 10
        end

        # C. Fresh unliked content prioritized
        score += 15 unless user_liked_ids.include?(disc.id)

        # D. Social proof / engagement
        score += [disc.likes.size, 15].min

        # E. Serendipity / Freshness jitter (ensures feed refreshes dynamically on every visit)
        score += rand(0..25)

        [disc, score]
      end

      scored.sort_by { |_, score| -score }.first(40).map(&:first)
    else
      # Guest user: rank by engagement, variety across genres, plus random freshness jitter
      scored = candidates.map do |disc|
        score = [disc.likes.size * 2, 25].min + rand(0..35)
        [disc, score]
      end
      scored.sort_by { |_, score| -score }.first(40).map(&:first)
    end
  end

  def set_discover
    @discover = Discover.find(params[:id])
  end

  def discover_params
    params.require(:discover).permit(:content, :likes, :plays, :saved, :start_time, :end_time, :dashboard_id, :title, :genre, :post_type, :video)
  end
end

class EventsController < ApplicationController
  before_action :set_event, only: %i[show edit update destroy]

  # GET /events/my_events
  def my_events
    # @user = current_user
    @applied_events = current_user.events
    @created_events = current_user.created_events
    authorize @created_events
    authorize @applied_events
  end

  # GET /events
  def index
    # @user = current_user
    @events = policy_scope(Event)
    @events = Event.all


    @events = @events.where(genre: params[:genre]) if params[:genre].present? && params[:genre] != "All"

    @markers = @events.geocoded.map do |event|
      {
        lat: event.latitude,
        lng: event.longitude,
        info_window_html: render_to_string(partial: "info_window", locals: { event: event })
      }
    end

    @genres = %w[Rock Pop Urban DJ Ballads Tropical Regional Country Instrumental Choir All]
    @genre_icon_classes = {
      "Rock" => "fa-solid fa-guitar",
      "Pop" => "fa-solid fa-headset",
      "Urban" => "fa-solid fa-building",
      "DJ" => "fa-solid fa-compact-disc",
      "Ballads" => "fa-solid fa-keyboard",
      "Tropical" => "fa-solid fa-umbrella-beach",
      "Regional" => "fa-solid fa-hat-cowboy",
      "Country" => "fa-solid fa-cow",
      "Instrumental" => "fa-solid fa-person-chalkboard",
      "Choir" => "fa-solid fa-people-group",
      "All" => "fa-solid fa-music"
    }
  end

  # GET /events/1
  def show
    @event = Event.find(params[:id])
    authorize @event

    if @event.geocoded?
      @marker = [{lat: @event.latitude, lng: @event.longitude}]
    end
  end

  # GET /events/new
  def new
    @event = Event.new
    authorize @event
  end

  # GET /events/1/edit
  def edit
    authorize @event
  end

  # POST /events
  def create
    @event = Event.new(event_params)
    @event.user = current_user
    authorize @event

    if @event.save
      redirect_to @event, notice: "Event was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /events/1
  def update
    authorize @event
    if @event.update(event_params)
      redirect_to @event, notice: "Event was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /events/1
  def destroy
    @event.destroy
    authorize @event
    redirect_to events_url, notice: "Event was successfully destroyed.", status: :see_other
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def event_params
    params.require(:event).permit(:title, :description, :datetime, :duration, :genre, :address, :user_id, :image)
  end
end

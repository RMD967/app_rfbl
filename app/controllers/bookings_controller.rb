class BookingsController < ApplicationController
  before_action :set_event, only: %i[new create edit update show]
  before_action :set_booking, only: %i[show destroy]

  def show
    authorize @booking
  end

  def create
    @booking = Booking.new
    authorize @booking

    if current_user.artist?
      @event = Event.find(params[:event_id])
      @booking.user = current_user
      @booking.event = @event

      @booking.date = @event.datetime.to_date
      @booking.status = true

      if @booking.save
        redirect_to my_bookings_path(@booking.event, @booking), status: :see_other, notice: 'Booking was successfully created.'
      else
        redirect_to event_path(@event), alert: "Something went wrong"
      end
    else
      redirect_to @event, alert: 'Only artists can apply to events.'
    end
  end

  def edit
    authorize @booking
  end

  def update
    authorize @booking
  end

  def destroy
    @booking.destroy
    authorize @booking
    redirect_to events_path, status: :see_other
  end

  def my_bookings
    @my_bookings = current_user.bookings.includes(:event)
    authorize @my_bookings
    # @user = current_user
  end

  private

  def set_booking
    @booking = Booking.find(params[:id])
  end

  def booking_params
    params.require(:booking).permit(:start_date, :end_date)
  end

  def set_event
    @event = Event.find(params[:event_id])
  end
end

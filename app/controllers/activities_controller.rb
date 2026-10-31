class ActivitiesController < ApplicationController
  before_action :authenticate_user!
  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped

  def index
    # Filter category: all, following, messages, interactions, bookings
    @current_category = params[:category].presence || "all"

    # Seed initial context notifications if user has very few (< 6)
    seed_initial_activities_if_needed if current_user.received_notifications.count < 6

    base = current_user.received_notifications.includes(:actor, :notifiable).recent

    @notifications = base.for_category(@current_category).limit(60)

    @counts = {
      all: base.count,
      following: base.for_category("following").count,
      messages: base.for_category("messages").count,
      interactions: base.for_category("interactions").count,
      bookings: base.for_category("bookings").count,
      unread: base.unread.count
    }

    # Load active bookings for the Bookings & Gigs subview
    @my_bookings = current_user.bookings.includes(event: :user).order(created_at: :desc)
  end

  private

  def seed_initial_activities_if_needed
    # 1. Followed artists or top performers new tracks/videos
    popular_discovers = Discover.includes(dashboard: :user).order(created_at: :desc).limit(8)
    popular_discovers.each_with_index do |disc, i|
      next unless disc.dashboard&.user && disc.dashboard.user != current_user

      current_user.received_notifications.find_or_create_by(
        action_type: "new_post",
        notifiable: disc,
        actor: disc.dashboard.user
      ) do |n|
        n.title = "#{disc.dashboard.artist_name} publicó #{disc.music? ? 'una nueva canción' : 'un nuevo video'}"
        n.content = disc.title
        n.target_url = "/discovers#discover_#{disc.id}"
        n.created_at = Time.current - (i * 2).hours - rand(5..45).minutes
        n.read_at = (i > 1 ? Time.current - 1.hour : nil)
      end
    end

    # 2. Chat messages from existing chatrooms or organizers
    Chatroom.joins(:chat_users).where(chat_users: { user_id: current_user.id }).each do |room|
      last_msg = room.messages.where.not(user_id: current_user.id).last
      if last_msg
        current_user.received_notifications.find_or_create_by(
          action_type: "new_message",
          notifiable: last_msg,
          actor: last_msg.user
        ) do |n|
          n.title = "Nuevo mensaje de #{last_msg.user.first_name}"
          n.content = last_msg.content.truncate(90)
          n.target_url = "/chatrooms/#{room.id}"
          n.created_at = last_msg.created_at
          n.read_at = nil
        end
      end
    end

    # 3. New followers from other artists
    User.where.not(id: current_user.id).where(artist: true).limit(3).each_with_index do |follower, i|
      current_user.received_notifications.find_or_create_by(
        action_type: "new_follower",
        notifiable: follower,
        actor: follower
      ) do |n|
        artist_title = follower.artist_dashboard&.artist_name || follower.full_name
        n.title = "#{artist_title} comenzó a seguirte"
        n.content = "Ahora está al tanto de tus próximas presentaciones y publicaciones."
        n.target_url = "/user/#{follower.id}"
        n.created_at = Time.current - (i + 1).days - rand(1..12).hours
        n.read_at = (i > 0 ? Time.current - 2.hours : nil)
      end
    end

    # 4. Gigs / Bookings updates
    current_user.bookings.includes(:event).each do |b|
      current_user.received_notifications.find_or_create_by(
        action_type: "booking_status",
        notifiable: b,
        actor: b.event.user
      ) do |n|
        status_text = b.status? ? "fue confirmada por el organizador 🎉" : "está en revisión por el organizador ⏳"
        n.title = "Tu postulación para #{b.event.title} #{status_text}"
        n.content = "Fecha del evento: #{b.event.datetime&.strftime('%d %b, %H:%M') || 'Próximamente'}. Lugar: #{b.event.address.to_s.split(',').first}"
        n.target_url = "/events/#{b.event.id}"
        n.created_at = b.created_at
        n.read_at = b.status? ? nil : Time.current - 1.day
      end
    end

    # 5. Likes and comments
    user_dash = current_user.artist_dashboard
    if user_dash
      user_dash.discovers.each do |disc|
        disc.comments.where.not(user_id: current_user.id).limit(2).each do |c|
          current_user.received_notifications.find_or_create_by(
            action_type: "new_comment",
            notifiable: c,
            actor: c.user
          ) do |n|
            n.title = "#{c.user.full_name} comentó en tu video"
            n.content = "\"#{c.content.truncate(70)}\""
            n.target_url = "/discovers#discover_#{disc.id}"
            n.created_at = c.created_at
            n.read_at = nil
          end
        end
      end
    end
  end
end

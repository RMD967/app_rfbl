class ChatroomsController < ApplicationController
  before_action :authenticate_user!

  def index
    # If accessed with user_id or artist_id parameter, find or create the chatroom directly
    target_id = params[:user_id].presence || params[:artist_id]
    if target_id.present?
      target_user = User.find_by(id: target_id) || Dashboard.find_by(id: target_id)&.user
      if target_user && target_user != current_user
        chatroom = current_user.chatrooms
                                .joins(:chat_users)
                                .where(chat_users: { user_id: target_user.id })
                                .first
        unless chatroom
          chat_name = "#{current_user.full_name} & #{target_user.full_name}"
          chatroom = Chatroom.create!(name: chat_name)
          ChatUser.create!(user: current_user, chatroom: chatroom)
          ChatUser.create!(user: target_user, chatroom: chatroom)
        end
        skip_policy_scope
        authorize chatroom
        redirect_to chatroom_path(chatroom) and return
      end
    end

    @chatrooms = policy_scope(Chatroom).includes(:users, :messages).order(updated_at: :desc)
    authorize Chatroom
  end

  def show
    @chatroom = Chatroom.find(params[:id])
    authorize @chatroom
    @message = Message.new
    @other_user = @chatroom.other_user(current_user)
  end

  def create
    target_id = params[:user_id].presence || params[:artist_id]
    @target_user = User.find_by(id: target_id) || Dashboard.find_by(id: target_id)&.user

    unless @target_user
      redirect_to chatrooms_path, alert: "User not found." and return
    end

    if @target_user == current_user
      redirect_to chatrooms_path, alert: "You cannot start a chat with yourself." and return
    end

    # Find an existing 1-on-1 chatroom between current_user and target_user
    @chatroom = current_user.chatrooms
                            .joins(:chat_users)
                            .where(chat_users: { user_id: @target_user.id })
                            .first

    unless @chatroom
      chat_name = if params[:event_id].present?
                    event = Event.find_by(id: params[:event_id])
                    "#{event&.title || 'Event'}: #{current_user.full_name} & #{@target_user.full_name}"
                  else
                    "#{current_user.full_name} & #{@target_user.full_name}"
                  end

      @chatroom = Chatroom.create!(name: chat_name)
      ChatUser.create!(user: current_user, chatroom: @chatroom)
      ChatUser.create!(user: @target_user, chatroom: @chatroom)
    end

    authorize @chatroom
    redirect_to chatroom_path(@chatroom)
  end

  def search_users
    authorize Chatroom
    query = params[:query].to_s.strip.downcase.sub(/\A@/, '')

    users = if query.blank?
              User.where.not(id: current_user.id)
                  .includes(:dashboards)
                  .order(created_at: :desc)
                  .limit(10)
            else
              User.where.not(id: current_user.id)
                  .left_joins(:dashboards)
                  .where(
                    "users.username ILIKE :q OR users.first_name ILIKE :q OR users.last_name ILIKE :q OR users.email ILIKE :q OR dashboards.artist_name ILIKE :q",
                    q: "%#{query}%"
                  )
                  .distinct
                  .includes(:dashboards)
                  .limit(15)
            end

    results = users.map do |u|
      avatar_url = if u.profile_picture.attached?
                     rails_blob_path(u.profile_picture, only_path: true)
                   else
                     "https://res.cloudinary.com/djuhjudsb/image/upload/v1687887823/tq49o29k_ofz8ad.png"
                   end
      artist_info = u.artist_dashboard
      {
        id: u.id,
        name: u.full_name,
        username: u.display_handle,
        is_artist: u.artist?,
        artist_name: artist_info&.artist_name,
        genre: artist_info&.artist_genre,
        avatar_url: avatar_url
      }
    end

    render json: results
  end

  def destroy
    @chatroom = Chatroom.find(params[:id])
    authorize @chatroom
    @chatroom.destroy
    redirect_to chatrooms_path, notice: "Conversation closed.", status: :see_other
  end
end

class ChatroomsController < ApplicationController
  before_action :authenticate_user!

  def index
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
    @target_user = User.find(params[:user_id])

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

  def destroy
    @chatroom = Chatroom.find(params[:id])
    authorize @chatroom
    @chatroom.destroy
    redirect_to chatrooms_path, notice: "Conversation closed.", status: :see_other
  end
end

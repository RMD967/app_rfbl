class ChatroomsController < ApplicationController

  def index
    @chatroom = policy_scope(Chatroom)
    authorize @chatroom
  end

  def show
    @chatroom = Chatroom.find(params[:id])
    @message = Message.new
    authorize @chatroom
  end

  def create
    @user = User.find(params[:user_id])
    if @user.artist?
      @chatroom = Chatroom.where(user_id: current_user.id, artist_id: @user.id).first_or_create
      authorize @chatroom
      ChatUser.create(user: current_user, chatroom: @chatroom)
      ChatUser.create(user: @user, chatroom: @chatroom)
      redirect_to chatroom_path(@chatroom)
    else
      authorize Chatroom # or any other object you want to authorize
      redirect_to root_path # or any other path you want to redirect the user to
    end
  end

  def destroy
    @chatroom.destroy
    authorize @chatroom
    redirect_to @chatrooms_url, notice: "Chatroom was successfully destroyed.", status: :see_other
  end
end

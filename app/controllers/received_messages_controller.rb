class ReceivedMessagesController < ApplicationController
=begin
  def create
    @user = User.find(params[:user_id])
    @message = @user.received_messages.build(message_params)

    if @message.save
      redirect_to chatroom_path(@message.chatroom), notice: "Message sent successfully"
    else
      # redirect_to event_path(@event), alert: "Something went wrong"
      redirect_to chatroom_path(@user.chatroom), alert: "Something went wrong"
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
=end

  def create
    @user = User.find(params[:user_id])
    @message = @user.received_messages.build(message_params)

    if @message.save
      ChatroomChannel.broadcast_to(
        @message.chatroom,
        render_to_string(partial: "messages/message", locals: { message: @message })
      )
      head :ok
    else
      redirect_to event_path(@event), alert: "Something went wrong"
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end

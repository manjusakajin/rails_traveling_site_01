class MessagesController < ApplicationController
  def create
    message = Message.new message_params
    message.user = current_user
    return unless message.save
    ActionCable.server.broadcast "messages_#{message.chatroom_id}_channel",
      message: render_to_string(partial: "messages/message",
        locals: {message: message})
    head :ok
  end

  private

  def message_params
    params.require(:message).permit :content, :chatroom_id
  end
end

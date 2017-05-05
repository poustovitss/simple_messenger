class MessagesController < ApplicationController
  before_action :set_conversation, only: :create

  def create
    @message = @conversation.messages.new(message_params)
    if @message.save
      @message.update(to: set_recipient)
      ActionCable.server.broadcast "messages_channel_#{@conversation.id}",
                                   message: render_message(@message, @conversation)
    else
      redirect_to conversation_path(@conversation), alert: 'Error'
    end
  end

  def unread
    @messages = current_user.new_messages
  end

  private

  def render_message(message, conversation)
    render(partial: 'messages/message', locals: { message: message,
                                                  conversation: conversation })
  end

  def set_conversation
    @conversation = Conversation.find(params[:conversation_id])
  end

  def message_params
    params.require(:message).permit(:body, :user_id)
  end

  def set_recipient
    if current_user.id == @conversation.sender_id
      @conversation.recipient_id
    else
      @conversation.sender_id
    end
  end
end

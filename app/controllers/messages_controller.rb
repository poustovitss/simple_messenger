class MessagesController < ApplicationController
  before_action :set_conversation

  def create
    @message = @conversation.messages.new(message_params)
    if @message.save
      ActionCable.server.broadcast "messages_channel_#{@conversation.id}",
                                   message: render_message(@message, @conversation)
    else
      redirect_to conversation_path(@conversation), alert: 'Error'
    end
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
end

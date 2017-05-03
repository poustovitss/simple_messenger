class MessagesController < ApplicationController
  before_action :set_conversation
  before_action :set_message, only: :destroy

  def create
    @message = @conversation.messages.new(message_params)
    if @message.save
      redirect_to conversation_path(@conversation)
    else
      redirect_to conversation_path(@conversation),
                  alert: 'Message must be from 1 to 1000 symbols'
    end
  end

  def destroy
    if @message.owner?(current_user)
      @message.delete
      redirect_to conversation_path(@conversation)
    else
      redirect_to conversation_path(@conversation), alert: 'Its not your message'
    end
  end

  private

  def set_conversation
    @conversation = Conversation.find(params[:conversation_id])
  end

  def set_message
    @message = Message.find(params[:id])
  end

  def message_params
    params.require(:message).permit(:body, :user_id)
  end
end

class ConversationsController < ApplicationController
  before_action :set_conversation, only: %i[show destroy]

  def index
    params[:q] ||= {}
    @search = User.active.ransack(params[:q])
    @users = @search.result(distinct: true)
                    .paginate(page: params[:users_page], per_page: 15)
    @conversations = current_user.conversations
                     .paginate(page: params[:conversation_page], per_page: 10)
    @conversation = Conversation.new
  end

  def create
    @conversation = Conversation.new(conversation_params)
    if Conversation.between(params[:sender_id], params[:recipient_id]).exists?
      @conversation = Conversation.between(params[:sender_id],
                                           params[:recipient_id]).first
      redirect_to conversation_path(@conversation)
    else
      @conversation.save
      redirect_to @conversation
    end
  end

  def show
    if @conversation.owner?(current_user)
      @messages = @conversation.messages
      @message = @conversation.messages.new
    else
      redirect_to conversations_path, alert: 'Access denied'
    end
  end

  def destroy
    return unless @conversation.owner?(current_user)
    @conversation.messages.delete_all
    @conversation.delete
    redirect_to conversations_path
  end

  private

  def conversation_params
    params.require(:conversation).permit(:id, :sender_id, :recipient_id)
  end

  def set_conversation
    @conversation ||= Conversation.find(params[:id])
  end
end

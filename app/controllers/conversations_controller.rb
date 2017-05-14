class ConversationsController < ApplicationController
  before_action :set_conversation, only: %i[show destroy]

  def index
    params[:q] ||= {}
    @search = User.active.without_current_user(current_user).ransack(params[:q])
    @users = @search.result(distinct: true)
                    .paginate(page: params[:users_page], per_page: 15)
    @conversations = current_user.conversations
                     .paginate(page: params[:conversation_page], per_page: 10)
    @conversation = Conversation.new
  end

  def create
    @conversation = Conversation.new(conversation_params)
    old_conversation = Conversation.between(conversation_params[:sender_id],
                                                 conversation_params[:recipient_id])
    if old_conversation.exists?
      @conversation = old_conversation.first
    else
      @conversation.save
    end
    redirect_to @conversation
  end

  def show
    if @conversation.owner?(current_user)
      @conversation.mark_messages_as_read(current_user)
      @messages = @conversation.messages.for_display
      @message = @conversation.messages.new
    else
      redirect_to conversations_path, alert: 'Access denied'
    end
  end

  def destroy
    return unless @conversation.owner?(current_user)
    @conversation.destroy
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

class ConversationsController < ApplicationController
  before_action :set_recipient, :set_sender

  def index
    params[:q] ||= {}
    @search = User.active.ransack(params[:q])
    @users = @search.result(distinct: true).paginate(page: params[:users_page], per_page: 15)
    @conversations = current_user.conversations.paginate(page: params[:conversation_page], per_page: 10)
    @conversation = Conversation.new
  end

  def create
    @conversation = Conversation.new(conversation_params)
    if Conversation.between(params[:sender_id], params[:recipient_id]).present?
      @conversation = Conversation.between(params[:sender_id], params[:recipient_id]).first
      redirect_to conversation_messages_path(@conversation)
    else
      @conversation.save(conversation_params)
      redirect_to @conversation
    end
  end

  def show
    @conversation = Conversation.includes(:messages)
  end

  private

  def set_recipient
    @recipient = params[:set_recipient]
  end

  def set_sender
    @sender = params[:set_sender]
  end

  def conversation_params
    { sender_id: params[:sender_id],
      recipient_id: params[:recipient_id] }
  end
end

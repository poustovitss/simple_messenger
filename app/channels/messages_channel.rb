class MessagesChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.info params['conversation_id']
    stream_from "messages_channel_#{params['conversation_id']}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def send_message(data)
    Message.create!(body: data['message'],
                    conversation_id: data['conversation_id'],
                    user_id: current_user)
  end
end

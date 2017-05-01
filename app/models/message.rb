class Message < ApplicationRecord
  belongs_to :user
  belongs_to :conversation

  validates :body, :conversation_id, :user_id, presence: true

  def message_time
    created_at.strftime('%l:%M %p - %m/%d/%y')
  end
end

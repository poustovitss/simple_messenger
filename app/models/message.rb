class Message < ApplicationRecord
  belongs_to :user
  belongs_to :conversation

  validates :body, :conversation_id, :user_id, presence: true
  validates :body, length: { minimum: 1, maximum: 1000 }

  def message_time
    created_at.strftime('%H:%M:%S %B %d, %Y')
  end
end
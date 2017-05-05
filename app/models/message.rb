class Message < ApplicationRecord
  belongs_to :user
  belongs_to :conversation

  validates :body, :conversation_id, :user_id, presence: true
  validates :body, length: { minimum: 1, maximum: 1000 }

  scope :for_display, -> { order(:created_at).last(20) }
  scope :to, -> (id) { where(to: id) }
  scope :not_read, -> { where(read: false) }

  def message_time
    created_at.strftime('%H:%M:%S %B %d, %Y')
  end

  def owner?(current_user)
    return true if current_user.id == user_id
    false
  end

  def owner_name
    User.find(user_id).name
  end
end

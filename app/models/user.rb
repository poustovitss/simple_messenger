class User < ApplicationRecord
  after_initialize :set_default_role, if: :new_record?
  before_destroy :delete_conversations

  enum role: %i[user admin]

  validates :first_name, :last_name, presence: true, length: { in: 3..20 }

  scope :created, -> { order('created_at asc') }
  scope :active,  -> { where(active: true) }
  scope :without_current_user, ->(user) { where.not(id: user.id) }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def active_for_authentication?
    super && active
  end

  def name
    "#{first_name.capitalize} #{last_name.capitalize}"
  end

  def admin?
    role == 'admin'
  end

  def current_user?
    self == Current.user
  end

  def conversations
    Conversation.where('sender_id = ? OR recipient_id = ?', id, id)
  end

  def new_messages
    Message.to(id).unread
  end

  protected

  def delete_conversations
    conversations.destroy_all
  end

  def set_default_role
    self.role ||= :user
  end
end

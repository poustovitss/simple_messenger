class User < ApplicationRecord
  scope :created, -> { order('created_at asc') }

  enum role: %i[user admin]

  validates :first_name, :last_name, presence: true, length: { in: 3..20 }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  after_initialize :set_default_role, if: :new_record?

  def set_default_role
    self.role ||= :user
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
end

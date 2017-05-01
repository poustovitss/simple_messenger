class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  def admin_only
    redirect_to root_path, alert: 'Access denied' unless current_user.admin?
  end

  def set_current_user
    Current.user = current_user
    yield
  ensure
    Current.user = nil
  end
end

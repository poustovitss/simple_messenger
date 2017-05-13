class UsersController < ApplicationController
  include UsersHelper
  respond_to :html

  before_action :admin_only, except: %i[edit update]
  before_action :set_user, only: %i[edit update destroy role toggle_user_state role_update]
  before_action :check_current_user, only: %i[edit update]
  around_action :set_current_user, only: %i[index destroy]

  def index
    @users = User.created.paginate(per_page: 20, page: params[:page])
  end

  def new
    @user = User.new
  end

  def edit; end

  def create
    @user = User.new(user_params)
    flash[:notice] = 'User was created.' if @user.save
    respond_with(@user, location: users_path)
  end

  def update
    flash[:notice] = 'User was updated.' if @user.update(user_params)
    respond_with(@user, location: users_path)
  end

  def destroy
    if @user == current_user
      flash[:alert] = 'This user cannot be deleted.'
    else
      @user.destroy
      flash[:notice] = 'User was successfully deleted.'
    end
    redirect_to users_path
  end

  def role; end

  def role_update
    flash[:notice] = 'User\'s role was updated.' if @user.update(role_params)
    respond_with(@user, location: users_path)
  end

  def toggle_user_state
    if current_user == @user
      flash[:alert] = 'You cannot disable yourself.'
    else
      @user.toggle!(:active)
      flash[:notice] = toggle_flash_message(@user)
    end
    redirect_to users_path
  end

  private

  def set_user
    @user ||= User.find(params[:id])
  end

  def user_params
    params[:user].delete(:password) if params[:user][:password].blank?
    params[:user].delete(:password_confirmation) if params[:user][:password_confirmation].blank?
    params.require(:user).permit(:id,
                                 :first_name,
                                 :last_name,
                                 :email,
                                 :role,
                                 :password,
                                 :password_confirmation)
  end

  def role_params
    params.require(:user).permit(:id, :role)
  end

  def check_current_user
    if current_user.id != @user.id && current_user.role != 'admin'
      redirect_to root_path, alert: 'Access denied'
    end
  end
end

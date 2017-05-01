class UsersController < ApplicationController
  include UsersHelper

  before_action :admin_only
  before_action :set_user, only: [:edit, :update, :destroy, :role, :toggle_user_state]
  around_action :set_current_user, only: [:index, :destroy]

  def index
    @users = User.created.paginate(per_page: 20, page: params[:page])
  end

  def new
    @user = User.new
  end

  def edit; end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to users_path, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: :new, notice: 'Error! User was not created.' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to users_path, notice: 'User was successfully updated.' }
        format.json { render json: @user.to_json }
      else
        format.html { render :edit, alert: 'Error! User was not updated.' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
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
    respond_to do |format|
      if @user.update(user_role_params)
        format.html { redirect_to users_path, notice: 'User role was successfully updated.' }
        format.json { render json: @user.to_json }
      else
        format.html { render :edit, notice: 'error!' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def toggle_user_state
    if current_user == @user
      redirect_to users_path, alert: 'You cannot disable yourself.'
    else
      @user.toggle!(:active)
      redirect_to users_path, notice: toggle_flash_message(@user)
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
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

  def user_role_params
    params.permit(:id, :role)
  end
end

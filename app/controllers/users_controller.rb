class UsersController < ApplicationController
  before_action :find_user, only: [:edit, :update, :destroy]
  before_action :logged_in_user, except: [:new, :create]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]
  layout "user_layout", except: [:new, :create]

  def index
    @users = User.page(params[:page]).per Settings.paginate.per_user
  end

  def new
    @user = User.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:notice] = t "check_active"
      redirect_to root_url
    else
      flash[:danger] = t "fail_create"
      render :new
    end
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "sucess_update"
      redirect_to request.referrer
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "destroy_user_success"
    else
      flash[:danger] = t "destroy_user_fail"
    end
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def find_user
    @user = User.find_by id: params[:id]

    return if @user
    flash[:danger] = t "cant_find_user"
    redirect_to request.referrer || root_url
  end

  def correct_user
    redirect_to root_url unless @user.is_user? current_user
  end

  def admin_user
    redirect_to root_url unless current_user.is_admin?
  end
end

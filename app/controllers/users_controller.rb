class UsersController < ApplicationController
  load_and_authorize_resource param_method: :user_params

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
      flash[:success] = t "sucess_create"
      redirect_to root_url
    else
      flash[:danger] = t "create_fail"
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
end

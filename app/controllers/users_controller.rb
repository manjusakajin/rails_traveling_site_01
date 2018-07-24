class UsersController < ApplicationController
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

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end
end

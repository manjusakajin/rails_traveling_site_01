class SessionsController < ApplicationController
  before_action :find_user, only: :create

  def new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    if check_user
      if @user.is_actived?
        log_in @user
        params[:session][:remember_me] == "1" ? remember(@user) : forget(@user)
        flash.now[:success] = t "success.login"
      else
        flash[:warning] = t "warning.active"
      end
      redirect_to root_url
    else
      flash.now[:danger] = t "error.login"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private
  def find_user
    @user = User.find_by email: params[:session][:email].downcase

    return if @user
    flash.now[:danger] = t "cant_find_user"
    render :new
  end

  def check_user
    @user&.authenticate params[:session][:password]
  end
end

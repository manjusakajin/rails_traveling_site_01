class ParticipationsController < ApplicationController
  before_action :logged_in_user
  before_action :find_user, only: :create
  before_action :find_trip, only: [:create, :update, :destroy]
  before_action :check_user, only: [:create, :update]
  before_action :find_participation, only: [:update, :destroy]
  before_action :check_delete, only: :destroy
  before_action :check_index, only: :index

  def index
    if params[:user_id]
      @participations = current_user.participations.select_request
        .page(params[:page]).per Settings.paginate.per_page
    elsif params[:accepted] == "send_request"
      @participations = @trip.participations.select_request
        .page(params[:page]).per Settings.paginate.per_page
    else
      @participations = @trip.participations.join_in.
        page(params[:page]).per Settings.paginate.per_page
    end
  end

  def create
    @participation = @trip.participations.new user: @user,
      accepted: params[:accepted]
    if @participation.save
      if @participation.accepted == "join_in"
        flash[:success] = t "success.add_member"
      else
        flash[:success] = t "success.send_request"
      end
    else
      if @participation.accepted == "join_in"
        flash[:danger] = t "danger.add_member"
      else
        flash[:danger] = t "danger.send_request"
      end
    end
    redirect_to request.referrer
  end

  def update
    if @participation.join_in!
      flash[:success] = t "success.accept"
    else
      flash[:danger] = t "danger.accept"
    end
    redirect_to trip_participations_url @trip
  end

  def destroy
    if @participation.destroy
      flash[:success] = t "success.reject"
    else
      flash[:danger] = t "danger.reject"
    end
    redirect_to request.referrer
  end

  def update
    if @participation.join_in!
      flash[:success] = t "success.accept"
    else
      flash[:danger] = t "danger.accept"
    end
    redirect_to trip_participations_url @trip
  end

  def destroy
    if @participation.destroy
      flash[:success] = t "success.reject"
    else
      flash[:danger] = t "danger.reject"
    end
    redirect_to request.referrer
  end

  private

  def check_accepted?
    params[:accepted] == "join_in"
  end

  def find_user
    @user = if check_accepted?
              User.find_by id: params[:user_id]
            else
              current_user
            end

    return if @user
    flash[:danger] = t "danger.find_user"
    redirect_to root_url
  end

  def find_trip
    @trip = Trip.find_by id: params[:trip_id]

    return if @trip
    flash[:danger] = t "danger.find_trip"
    redirect_to root_url
  end

  def check_user
    if check_accepted?

      return if current_user.is_user? @trip.owner
    else

      return unless @trip.members.include? @user
    end
    flash[:danger] = t "danger.check_user"
    redirect_to root_url
  end

  def check_delete
    user = @participation.user
    if user.is_user? @trip.owner
      flash[:danger] = t "danger.out_group"
      redirect_to request.referrer
    else
      unless current_user.is_user?(user) ||
        current_user.is_user?(@trip.owner)
        flash[:danger] = t "danger.out_group"
        redirect_to request.referre
      end
    end
  end

  def find_participation
    if params[:user_id]
      user = User.find_by id: params[:user_id]
    end
    @participation = if params[:id]
                       Participation.find_by id: params[:id]
                     elsif params[:user_id]
                       user.particications.
                        find_by trip_id: params[:trip_id]
                     end

    return if @participation
    flash[:danger] = t "find_part"
    redirect_to root_url
  end

  def check_index
    if params[:user_id]
      find_user
    else
      find_trip
    end
  end
end

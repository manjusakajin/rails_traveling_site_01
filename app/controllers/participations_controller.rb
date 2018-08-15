class ParticipationsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_trip, only: [:index, :create, :destroy]
  before_action :check_user, only: :create
  before_action :find_participation, only: :destroy
  before_action :check_delete, only: :destroy

  def index
    @participations = @trip.participations.join_in
                           .page(params[:page]).per Settings.paginate.per
  end

  def create
    @participation = @trip.participations.new user: current_user,
      accepted: :send_request
    if @participation.save
      flash[:success] = t "success.send_request"
    else
      flash[:danger] = t "danger.send_request"
    end
    redirect_to request.referrer
  end

  def destroy
    if @participation.destroy
      flash[:success] = t "success.exit"
    else
      flash[:danger] = t "danger.exit"
    end
    redirect_to root_url
  end

  private

  def find_trip
    @trip = Trip.find_by id: params[:trip_id]

    return if @trip
    flash[:danger] = t "danger.find_trip"
    redirect_to root_url
  end

  def check_user
    return unless @trip.members.include? @user

    flash[:danger] = t "danger.check_user"
    redirect_to root_url
  end
<<<<<<< HEAD

  def check_delete
    user = @participation.user
    if user.is_user?(@trip.owner) || !current_user.is_user?(user)
      flash[:danger] = t "danger.out_group"
      redirect_to request.referrer
    end
  end

  def find_participation
    @participation = current_user.participations.find_by trip_id: @trip.id

    return if @participation
    flash[:danger] = t "find_part"
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
=======

  def check_delete
    user = @participation.user
    if user.is_user?(@trip.owner) || !current_user.is_user?(user)
      flash[:danger] = t "danger.out_group"
      redirect_to request.referrer
    end
  end

  def find_participation
    @participation = current_user.participations.find_by trip_id: @trip.id
>>>>>>> check_request

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

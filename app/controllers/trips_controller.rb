class TripsController < ApplicationController
  before_action :logged_in_user
  before_action :find_trip, :check_member, only: [:show]

  def index
    @trips = if params[:keyword]
               Trip.search_trip(params[:keyword])
                   .page(params[:page]).per_page
             else
               Trip.all.page(params[:page]).per_page
             end
  end

  def new
    @trip = Trip.new
    @places = Place.all
  end

  def create
    @trip = Trip.new trip_params
    if @trip.save
      flash[:success] = t "create_success"
      @trip.participations.create user: @trip.owner, accepted: :join_in
      redirect_to @trip
    else
      flash[:danger] = t "create_fail"
      render :new
    end
  end

  def show
    @user = User.find_by id: @trip.user_id

    if @user
      render layout: "layouts/trip_layout"
    else
      flash[:danger] = t "danger.find_user"
      redirect_to root_url
    end
  end

  private

  def trip_params
    params.require(:trip).permit :name, :user_id, :begin, :destination_id,
      place_attributes: [:name]
  end

  def find_trip
    @trip = Trip.find_by id: params[:id]

    return if @trip
    flash[:danger] = t "danger.find_trip"
    redirect_to root_url
  end

  def check_member
    @participation = Participation.find_by user_id: current_user.id

    return if @participation&.join_in?
    flash[:danger] = t "danger.not_member"
    redirect_to root_url
  end
end

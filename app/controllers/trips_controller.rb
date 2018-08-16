class TripsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_trip, only:[:show, :destroy]
  before_action :check_member, only:[:show, :destroy]
  before_action :check_delete, only: [:destroy]
  layout "trip_layout", only: :show

  def index
    @trips = if params[:user_id]
               Kaminari.paginate_array(select_trips current_user.trips).
                page(params[:page]).per Settings.paginate.per
             elsif params[:keyword]
               Trip.search_trip(params[:keyword]).
                page(params[:page]).per_page
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
      @chatroom = Chatroom.create topic: @trip.name, slug: @trip.id
      redirect_to @trip
    else
      flash[:danger] = t "create_fail"
      render :new
    end
  end

  def show
    @content = params[:content] || @trip.name
    @chatroom = Chatroom.find_by slug: @trip.id
    if @chatroom
      @messages = @chatroom.messages.last 10
      @message = Message.new
    end
    @user = @trip.owner
  end

  def destroy
    if @trip.destroy
      flash[:success] = t "delete_success"
    else
      flash[:danger] = t "delete_fail"
    end
    redirect_to root_url
  end

  private

  def select_trips trips
    my_trip = []
    trips.each do |trip|
      participation = current_user.participations.find_by trip_id: trip.id
      if participation.join_in?
        my_trip << trip
      end
    end
    return my_trip
  end

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

  def check_delete

     return if current_user.is_user?(@trip.owner) || current_user.is_admin?
     flash[:danger] = t "can_not_delete"
     redirect_to root_url
   end

  def check_member
    @participation = @trip.participations.find_by user_id: current_user.id

    return if @participation&.join_in?
    flash[:danger] = t "not_member"
    redirect_to root_url
  end
end

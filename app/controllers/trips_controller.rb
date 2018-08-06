class TripsController < ApplicationController
  before_action :logged_in_user
  before_action :find_trip, except: [:index, :new, :create]
  before_action :check_member, except: [:index, :new, :create]
  before_action :check_delete, only: [:update, :destroy, :edit]
  layout "trip_layout", except: [:index, :new, :create]

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
    if @content == @trip.name
      @notifications = @trip.notifications.order(created_at: :DESC)
    end
    @chatroom = Chatroom.find_by slug: @trip.id
    if @chatroom
      @messages = @chatroom.messages.last 10
      @message = Message.new
    end
    @user = @trip.owner
  end

  def edit
    @field = params[:field]
  end

  def update
    if params[:trip][:field] == "plant"
      @trip.update_attributes(plant: params[:trip][:plant])
      @trip.notifications.create event: "Plant updated"
      flash[:success] = "Plant updated"
    elsif params[:trip][:field] == "expense"
      @trip.update_attributes(expense: params[:trip][:expense])
      @trip.notifications.create event: "Expense updated"
      flash[:success] = "Expense updated"
    else
      flash[:danger] = "Can not update"
    end
    redirect_to @trip
  end

  def destroy
    if @trip.destroy
      flash[:success] = "Delete success"
    else
      flash[:danger] = "Delete fail"
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
     flash[:danger] = "You can not delete"
     redirect_to root_url
   end

  def check_member
    @participation = @trip.participations.find_by user_id: current_user.id

    return if @participation&.join_in?
    flash[:danger] = "You are not member"
    redirect_to root_url
  end
end

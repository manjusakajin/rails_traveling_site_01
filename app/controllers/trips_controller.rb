class TripsController < ApplicationController
  load_and_authorize_resource param_method: :trip_params
  layout "trip_layout", only: :show

  def index
    @q = Trip.ransack(params[:q])
    @trips = if params[:user_id]
               Kaminari.paginate_array(select_trips(current_user.trips))
                       .page(params[:page]).per Settings.paginate.per
             elsif @q
               @q.result.page(params[:page]).per_page
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
      my_trip << trip if participation.join_in?
    end
    my_trip
  end

  def trip_params
    params.require(:trip).permit :name, :user_id, :begin, :destination_id,
      place_attributes: [:name]
  end
end

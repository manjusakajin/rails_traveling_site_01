class Owner::TripsController < ApplicationController
  before_action :logged_in_user, :find_trip, :check_owner
  layout "trip_layout", only: :edit

  def edit
    @field = params[:field]
  end

  def update
    if @trip.update_attributes trip_params
      flash[:success] = t "update_success"
    else
      flash[:danger] = t "update_fail"
    end
    redirect_to @trip
  end

  private

  def trip_params
    params.require(:trip).permit :plant, :expense
  end

  def find_trip
    @trip = Trip.find_by id: params[:id]

    return if @trip
    flash[:danger] = t "danger.find_trip"
    redirect_to root_url
  end

  def check_owner
    current_user.is_user? @trip.owner
  end
end

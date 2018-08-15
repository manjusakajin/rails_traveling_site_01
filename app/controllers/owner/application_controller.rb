class Owner::ApplicationController < ApplicationController
  before_action :authenticate_user!
  before_action :find_trip, :check_owner

  def find_trip
    @trip = Trip.find_by id: params[:trip_id]

    return if @trip
    flash[:danger] = t "danger.find_trip"
    redirect_to root_url
  end

  def check_owner
    current_user.is_user? @trip.owner
  end
end

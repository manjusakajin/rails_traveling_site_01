class NotificationsController < ApplicationController
  before_action :find_trip, only: [:create, :new]

  def new
    @notification = Notification.new
  end

  def create
    @notification = @trip.notifications.new params_notification
    if @notification.save
      flash[:success] = "Send notification success"
    else
      flash[:danger] = "Send notification fail"
    end
    redirect_to @trip
  end

  private

  def find_trip
    @trip = Trip.find_by id: params[:trip_id]

    return if @trip
    flash[:danger] = "Can not find trip"
    redirect_to root_url
  end

  def params_notification
    params.require(:notification).permit :event
  end
end

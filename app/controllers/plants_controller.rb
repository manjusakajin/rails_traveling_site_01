class PlantsController < ApplicationController
  before_action :authenticate_user!

  def new
    @plant = Plant.new
  end

  def create
    @plant = Plant.new plant_params
    if @plant.save
      cont = t("plant_note") + @plant.description + t("at") + @plant.place.name
      flash[:success] = t "create_success"
      message = Message.new(:content => cont, :chatroom_id => @plant.trip.chatroom.id)
      message.user = current_user

      return unless message.save
      redirect_to trip_path(@plant.trip_id, content: "plant")
    else
      flash[:danger] = t "create_fail"
      redirect_to trips_path
    end
  end

  def destroy
    @plant = Plant.find_by id: params[:id]
    trip_id = @plant.trip_id
    if !@plant
      flash[:danger] = t "find_plant_fail"
      redirect_to trips_path
    else
      if @plant.destroy
        cont = t("plant_note") + @plant.description + t("canceled")
        flash[:success] = t "create_success"
        message = Message.new(:content => cont, :chatroom_id => @plant.trip.chatroom.id)
        message.user = current_user

        return unless message.save
        flash[:success] = t "delete_success"
        redirect_to trip_path trip_id, content: "plant"
      else
        flash[:danger] = t "delete_fail"
        redirect_to trips_path
      end
    end
  end

  private

  def plant_params
    params.require(:plant).permit :description, :trip_id, :place_id, place_attributes: [:name]
  end
end

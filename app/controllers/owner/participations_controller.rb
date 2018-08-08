class Owner::ParticipationsController < Owner::ApplicationController
  before_action :find_participation, only: [:update, :destroy]
  before_action :find_user, only: :create

  def index
<<<<<<< HEAD
    @participations = @trip.participations.send_request
                           .page(params[:page])
                           .per Settings.paginate.per
=======
    @participations = @trip.participations.select_request
                           .page(params[:page])
                           .per Settings.paginate.per_page
>>>>>>> check_request_2
  end

  def create
    @participation = @trip.participations.new user: @user,
      accepted: :join_in
    if @participation.save
      flash[:success] = t "success.add_member"
    else
      flash[:danger] = t "danger.add_member"
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

  def find_participation
    @participation = Participation.find_by id: params[:id]

    return if @participation
    flash[:danger] = t "danger.find_part"
    redirect_to root_url
  end

  def find_user
    @user = User.find_by id: params[:user_id]

    return if @user
    flash[:danger] = t "danger.find_user"
    redirect_to root_url
  end
end

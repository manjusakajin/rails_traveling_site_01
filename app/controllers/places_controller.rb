class PlacesController < ApplicationController
  def new
    @place = Place.new
  end

  def create
    @place = current_user.reviews.build review_params
    if @review.save
      flash[:success] = t "create_review_success"
      redirect_to @review
    else
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @review.update_attributes review_params
      flash[:success] = t "update_review_success"
      redirect_to @review
    else
      render :edit
    end
  end

  def destroy
    @review.destroy
    flash[:success] = t "delete_review_success"
    redirect_to request.referrer || reviews_url
  end

  private

  def review_params
    params.require(:review).permit :title, :content, :hastags_list
  end

  def correct_user
    if current_user.admin?
      find_review
    else
      @review = current_user.reviews.find_by id: params[:id]
    end
    redirect_to reviews_url if @review.nil?
  end

  def find_review
    @review = Review.find_by id: params[:id]

    return if @review
    flash.now[:danger] = t "cant_find_review"
    redirect_to request.referrer || reviews_url
  end
end

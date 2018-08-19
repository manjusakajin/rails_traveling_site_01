class ReviewsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_review, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]

  def index
    @reviews = if params[:keyword]
                 Review.search_review(params[:keyword]).order_by_time
                       .page(params[:page]).per Settings.paginate.per
               elsif params[:field] == "my_reviews"
                 current_user.reviews.page(params[:page])
                             .per Settings.paginate.per
               else
                 Review.order_by_time.page(params[:page])
                       .per Settings.paginate.per
               end
    @top_hastags = Hastag.order_by_count
  end

  def new
    @review = Review.new
  end

  def create
    @review = current_user.reviews.build review_params
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

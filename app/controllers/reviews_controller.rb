class ReviewsController < ApplicationController
  load_and_authorize_resource param_method: :review_params

  def index
    @q = Review.ransack(params[:q])
    @reviews = if @q
                  @q.result.order_by_time.page(params[:page])
                    .per Settings.paginate.per
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
end

class HastagsController < ApplicationController
  before_action :find_hastag

  def show
    @q = @hastag.reviews.ransack(params[:q])
    @reviews = if @q
                  @q.result.order_by_time.page(params[:page])
                    .per Settings.paginate.per
               else @hastag.reviews.order_by_time.page(params[:title])
                           .per Settings.paginate.per
               end
    @top_hastags = Hastag.order_by_count
    render "reviews/index"
  end

  private

  def find_hastag
    @hastag = Hastag.find_by title: params[:title]

    return if @hastag
    flash.now[:danger] = t "cant_find_hastag"
    redirect_to request.referrer || reviews_url
  end
end

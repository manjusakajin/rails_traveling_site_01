class CommentsController < ApplicationController
  before_action :find_commentable
  load_and_authorize_resource param_method: :comment_params

  def new
    @comment = Comment.new
  end

  def create
    @comment = @commentable.comments.new comment_params
    if @comment.save
      if params[:comment_id]
        channel = "comments_#{params[:comment][:review_id]}_channel"
        comment_id = params[:comment_id]
      else
        channel = "comments_#{params[:review_id]}_channel"
      end
      ActionCable.server.broadcast channel,
        comment: render_to_string(partial: "comments/comment",
          locals: {comment: @comment}),
        comment_other: render_to_string(partial: "comments/comment_other",
          locals: {comment: @comment}),
        user: @comment.user_id,
        type: @comment.commentable_type,
        comment_id: comment_id
      head :ok
    else
      flash.now[:danger] = t "error.create_comment"
    end
  end

  def update
    @comment.update_attributes body: params[:comment][:body]
  end

  def destroy
    return if @comment.destroy
    flash.now[:danger] = t "error.delete_comment"
  end

  private

  def comment_params
    params.require(:comment).permit :body, :user_id
  end

  def find_commentable
    @commentable = if params[:comment_id]
                     Comment.find_by_id params[:comment_id]
                   else
                     Review.find_by_id params[:review_id]
    end
  end
end

class Owner::SearchsController < Owner::ApplicationController
  def index
    @q = User.ransack(params[:q])
    @users = if @q
               @q.result.page(params[:page])
                    .per Settings.paginate.per_user
             else
               User.page(params[:page]).per Settings.paginate.per_user
             end
  end
end

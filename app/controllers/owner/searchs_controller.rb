class Owner::SearchsController < Owner::ApplicationController
  def index
    @users = if params[:keyword]
               User.search(params[:keyword]).page(params[:page]).per_page
             else
               User.all.page(params[:page]).per_page
             end
  end
end

class ResultsController < ApplicationController
  def index
     @pg_search_documents = PgSearch.multisearch(params[:query])
     @pg_search_users = @pg_search_documents.where(searchable_type: "User").page(params[:page1]).per(Settings.paginate.per)
     @pg_search_reviews = @pg_search_documents.where(searchable_type: "Review").page(params[:page2]).per(Settings.paginate.per)
     @pg_search_trips = @pg_search_documents.where(searchable_type: "Trip").page(params[:page3]).per(Settings.paginate.per)
  end
end

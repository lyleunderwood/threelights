class SearchController < ApplicationController
  def index
    @search = Search.new
    @search.query = params[:query]
    @search.type = params[:type]
    @search.page = params[:page]
    @search.run
  end
end

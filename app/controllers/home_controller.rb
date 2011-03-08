class HomeController < ApplicationController
  def index
    @categories = Category.find_by_name('ROOT').children
  end
end

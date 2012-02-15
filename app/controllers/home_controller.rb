class HomeController < ApplicationController
  def index
    Rails.cache.fetch(:root_categories) do
      @categories = Category.find_by_name('ROOT', :include => [{:children => :children}]).children
    end
  end
end

class Category < ActiveRecord::Base
  acts_as_nested_set

  slug :name

  has_many :albums

  def contained_albums
    categories = descendants + [self]

    sub_albums = []
    categories.each do |category|
      sub_albums = sub_albums + category.albums
    end
    sub_albums
  end
  
  def contained_images
    sub_images = []
    contained_albums.each do |album|
      sub_images = sub_images + album.images
    end
    sub_images
  end

end

require File.join(Rails.root, 'lib', 'searchable')

class Category < ActiveRecord::Base
  include ::Searchable

  acts_as_nested_set :before_add => :category_added

  slug :name

  has_many :albums, :order => :position

  def contained_albums
    self_and_descendants.map(&:albums).flatten
  end

  def contained_images
    contained_albums.map(&:images).flatten
  end

  def image_count
    return self[:image_count] if self[:image_count]
    self[:image_count] = contained_images.count
    save!

    self[:image_count]
  end

  def category_added
    # doesn't get called for some reason
  end

  def increment_image_count!(amount = 1)
    self.image_count = self.image_count + amount
    save!
  end

  def decrement_image_count!(amount = 1)
    self.image_count = self.image_count - amount
    save!
  end

  def images(limit = 8, order = nil)
    album_ids = contained_albums.map {|a| a.id}
    return [] if album_ids.blank?

    images = Image.where('album_id IN(' + album_ids.join(',') + ')')
    images = images.limit(limit) if limit
    images = images.order(order) if order
    images
  end

end

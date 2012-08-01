class Album < ActiveRecord::Base
  has_many :images
  belongs_to :category

  slug :name

  belongs_to :cover, :inverse_of => :covered_album, :class_name => 'Image'
end

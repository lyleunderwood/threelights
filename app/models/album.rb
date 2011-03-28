class Album < ActiveRecord::Base
  has_many :images
  belongs_to :category

  slug :name
end

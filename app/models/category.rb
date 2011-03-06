class Category < ActiveRecord::Base
  acts_as_nested_set

  slug :name

  has_many :albums
end

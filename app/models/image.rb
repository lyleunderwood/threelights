class Image < ActiveRecord::Base
  has_attached_file :subject, :styles => {:thumb => "100x100>", :view => "600x400>"}

  belongs_to :album

  slug :name

  def viewed!
    self.views = self.views + 1
    save!
  end

  def self.random category = nil, limit = nil
    if category
      category.images(limit, 'RAND()')
    else
      Image.order('RAND()').limit(8).all
    end
  end
end

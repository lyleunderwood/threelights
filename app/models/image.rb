class Image < ActiveRecord::Base
  has_attached_file :subject, :styles => {:thumb => "100x100>", :view => "600x400>"}

  belongs_to :album

  def viewed!
    self.views = self.views + 1
    save!
  end
end

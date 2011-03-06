class Image < ActiveRecord::Base
  has_attached_file :subject, :styles => {:thumb => "75x75#", :view => "600x400>"}

  belongs_to :album
end

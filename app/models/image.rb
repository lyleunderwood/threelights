class Image < ActiveRecord::Base
  has_attached_file :subject,
    :styles => {
        :thumb => "100x100>", :view => "600x400>"
      },
      :storage => :s3,
      :s3_credentials => "#{Rails.root}/config/s3.yml",
      :path => "/:style/:id/:filename"

  belongs_to :album

  after_post_process :write_dimensions

  slug :name
  before_validation :normalize_name

  def write_dimensions
    geo = Paperclip::Geometry.from_file(subject.queued_for_write[:original])
    self.width = geo.width
    self.height = geo.height

    true
  end

  def normalize_name
    write_attribute(:name, subject_file_name) if name.blank?

    true
  end

  def viewed!
    self.views = self.views + 1
    save!
  end

  def self.random category = nil, limit = nil
    if category
      category.images(limit, 'RAND()').includes(:album => :category)
    else
      Image.includes(:album => :category).order('RAND()').limit(8).all
    end
  end
end

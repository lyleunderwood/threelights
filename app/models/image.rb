require File.join(Rails.root, 'lib', 'searchable')

class Image < ActiveRecord::Base
  include ::Searchable

  has_attached_file :subject,
    :styles => {
        :thumb => "100x100>", :view => "600x400>"
      },
    :storage => :s3,
    :s3_credentials => "#{Rails.root}/config/s3.yml",
    :path => "/:style/:id/:filename"

  belongs_to :album

  has_one :covered_album, :inverse_of => :cover, :class_name => 'Album'

  after_post_process :write_dimensions

  slug :name
  before_validation :normalize_name

  after_create do
    album.expire_archive
    #album.increment_image_count!
  end

  after_destroy do
    album.expire_archive
    album.decrement_image_count!
  end

  after_save do
    return unless changed.include? 'album_id'

    album.expire_archive
    album.increment_image_count!

    return unless old_album_id = changes['album_id'][0]

    old_album = Album.find(old_album_id)
    old_album.expire_archive
    old_album.decrement_image_count!
  end

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
      category.images(limit, 'RAND()')
    else
      Image.order('RAND()').limit(8).all
    end
  end
end

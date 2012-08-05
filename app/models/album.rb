require 'zip/zip'

class Album < ActiveRecord::Base
  has_many :images
  belongs_to :category

  slug :name

  belongs_to :cover, :inverse_of => :covered_album, :class_name => 'Image'

  has_attached_file :archive,
    :path => "/tmp/album_archives/:filename"

  def expire_archive
    archive.destroy
    save!
  end

  def to_zip
    return archive if archive.present?

    file = ::Tempfile.new("album-zip-#{name}")

    Zip::ZipOutputStream.open(file.path) do |stream|
      images.each do |image|
        stream.put_next_entry(image.subject_file_name)
        stream.print IO.read(image.subject.to_file.path)
      end
    end

    self.archive = file
    save!

    file
  end
end

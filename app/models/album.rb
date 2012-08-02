require 'zip/zip'

class Album < ActiveRecord::Base
  has_many :images
  belongs_to :category

  slug :name

  belongs_to :cover, :inverse_of => :covered_album, :class_name => 'Image'

  def to_zip
    file = ::Tempfile.new("album-zip-#{name}")

    Zip::ZipOutputStream.open(file.path) do |stream|
      images.each do |image|
        stream.put_next_entry(image.subject_file_name)
        stream.print IO.read(image.subject.to_file.path)
      end
    end

    file
  end
end

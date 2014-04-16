require 'zip/zip'
require File.join(Rails.root, 'lib', 'searchable')

class Album < ActiveRecord::Base
  include ::Searchable

  has_many :images
  belongs_to :category

  slug :name

  belongs_to :cover, :inverse_of => :covered_album, :class_name => 'Image'

  has_attached_file :archive,
    :path => "/tmp/album_archives/:filename"

  acts_as_list :scope => :category

  def expire_archive
    archive.destroy
    save!
  end

  def image_count
    return self[:image_count] if self[:image_count]
    self[:image_count] = images.count
    save!

    self[:image_count]
  end

  def increment_image_count!(amount = 1)
    self.image_count = self.image_count + amount
    save!
    category.self_and_ancestors.each(&:increment_image_count!)
  end

  def decrement_image_count!(amount = 1)
    self.image_count = self.image_count - amount
    save!
    category.self_and_ancestors.each(&:decrement_image_count!)
  end

  after_create do
    category.self_and_ancestors.each do |cat|
      cat.increment_image_count!(image_count)
    end if image_count > 0
  end

  after_destroy do
    old_category.self_and_ancestors.each do |cat|
      cat.decrement_image_count!(image_count)
    end if image_count > 0
  end

  after_save do
    return unless changed.include? 'category_id'

    category.self_and_ancestors.each do |cat|
      cat.increment_image_count!(image_count)
    end

    return unless old_category_id = changes['category_id'][0]

    old_category = Category.find(old_category_id)
    old_category.self_and_ancestors.each do |cat|
      cat.decrement_image_count!(image_count)
    end
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

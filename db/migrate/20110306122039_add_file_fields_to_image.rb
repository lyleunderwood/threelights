class AddFileFieldsToImage < ActiveRecord::Migration
  def self.up
    add_column :images, :subject_file_name, :string
    add_column :images, :subject_content_type, :string
    add_column :images, :subject_file_size, :integer
    add_column :images, :subject_updated_at, :datetime
  end

  def self.down
  end
end

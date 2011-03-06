class AddAssociations < ActiveRecord::Migration
  def self.up
    add_column :images, :album_id, :integer
    add_column :albums, :category_id, :integer
  end

  def self.down
  end
end

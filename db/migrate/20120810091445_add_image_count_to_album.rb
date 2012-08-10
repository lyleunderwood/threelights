class AddImageCountToAlbum < ActiveRecord::Migration
  def change
    add_column :albums, :image_count, :integer

  end
end

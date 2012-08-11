class AddIndexesToAlbum < ActiveRecord::Migration
  def change
    add_index :albums, :slug

    add_index :albums, :category_id

    add_index :albums, :legacy_id

    add_index :albums, :archive_file_name

    add_index :albums, :image_count

  end
end

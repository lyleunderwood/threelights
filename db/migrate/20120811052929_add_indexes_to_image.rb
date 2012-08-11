class AddIndexesToImage < ActiveRecord::Migration
  def change
    add_index :images, :slug

    add_index :images, :subject_file_name

    add_index :images, :album_id

    add_index :images, :views

    add_index :images, :legacy_pos

    add_index :images, :legacy_id

    add_index :images, :created_at

  end
end

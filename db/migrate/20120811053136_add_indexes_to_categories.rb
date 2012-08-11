class AddIndexesToCategories < ActiveRecord::Migration
  def change
    add_index :categories, :parent_id

    add_index :categories, :lft

    add_index :categories, :rgt

    add_index :categories, :slug

    add_index :categories, :legacy_id

    add_index :categories, :image_count

  end
end

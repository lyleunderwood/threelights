class AddImageCountToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :image_count, :integer

  end
end

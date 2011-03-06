class CategoryActsAsNestedSet < ActiveRecord::Migration
  def self.up
    add_column :categories, :parent_id, :integer
    add_column :categories, :lft, :integer
    add_column :categories, :rgt, :integer
  end

  def self.down
  end
end

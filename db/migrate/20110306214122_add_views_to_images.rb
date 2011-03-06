class AddViewsToImages < ActiveRecord::Migration
  def self.up
    add_column :images, :views, :integer, :default => 0
  end

  def self.down
    remove_column :images, :views
  end
end

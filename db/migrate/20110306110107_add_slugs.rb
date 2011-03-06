class AddSlugs < ActiveRecord::Migration
  def self.up
    add_column :categories, :slug, :string
    add_column :albums, :slug, :string
    add_column :images, :slug, :string
  end

  def self.down
  end
end

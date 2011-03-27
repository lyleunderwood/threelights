class AddLegacyIdToAlbum < ActiveRecord::Migration
  def self.up
    add_column :albums, :legacy_id, :integer
  end

  def self.down
    remove_column :albums, :legacy_id
  end
end

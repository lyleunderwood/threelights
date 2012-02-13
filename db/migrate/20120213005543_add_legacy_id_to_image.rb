class AddLegacyIdToImage < ActiveRecord::Migration
  def self.up
    add_column :images, :legacy_id, :integer
  end

  def self.down
    remove_column :images, :legacy_id
  end
end

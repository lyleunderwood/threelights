class AddLegacyPosToImage < ActiveRecord::Migration
  def self.up
    add_column :images, :legacy_pos, :integer
  end

  def self.down
    remove_column :images, :legacy_pos
  end
end

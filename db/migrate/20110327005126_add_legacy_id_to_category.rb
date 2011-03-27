class AddLegacyIdToCategory < ActiveRecord::Migration
  def self.up
    add_column :categories, :legacy_id, :integer
  end

  def self.down
    remove_column :categories, :legacy_id
  end
end

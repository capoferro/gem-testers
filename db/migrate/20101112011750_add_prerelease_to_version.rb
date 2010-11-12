class AddPrereleaseToVersion < ActiveRecord::Migration
  def self.up
    add_column :versions, :prerelease, :boolean
  end

  def self.down
    remove_column :versions, :prerelease
  end
end

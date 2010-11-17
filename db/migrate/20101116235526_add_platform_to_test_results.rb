class AddPlatformToTestResults < ActiveRecord::Migration
  def self.up
    add_column :test_results, :platform, :string
  end

  def self.down
    remove_column :test_results, :platform
  end
end

class AddPlatform < ActiveRecord::Migration
  def self.up
    add_column :test_results, :platform, :string
    execute "update test_results set platform='ruby'";
  end

  def self.down
    remove_column :test_results, :platform
  end
end

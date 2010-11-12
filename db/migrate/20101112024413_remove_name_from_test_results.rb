class RemoveNameFromTestResults < ActiveRecord::Migration
  def self.up
    remove_column :test_results, :name
  end

  def self.down
    add_column :test_results, :name, :string
  end
end

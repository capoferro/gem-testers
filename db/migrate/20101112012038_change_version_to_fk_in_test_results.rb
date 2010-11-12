class ChangeVersionToFkInTestResults < ActiveRecord::Migration
  def self.up
    remove_column :test_results, :version
    add_column :test_results, :version_id, :integer
  end

  def self.donw
    add_column :test_results, :version, :string
    remove_column :test_results, :version_id
  end
end

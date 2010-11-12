class AddRubygemIdToTestResults < ActiveRecord::Migration
  def self.up
    add_column :test_results, :rubygem_id, :integer
  end

  def self.down
    remove_column :test_results, :rubygem_id
  end
end

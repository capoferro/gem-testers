class AddRubyVersionToTestResults < ActiveRecord::Migration
  def self.up
    add_column :test_results, :ruby_version, :string
  end

  def self.down
    remove_column :test_results, :ruby_version
  end
end

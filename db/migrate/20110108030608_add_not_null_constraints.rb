class AddNotNullConstraints < ActiveRecord::Migration
  def self.up
    change_column :test_results, :version_id, :integer, null: false
    change_column :test_results, :rubygem_id, :integer, null: false
    change_column :rubygems, :name, :string, null: false
    change_column :versions, :rubygem_id, :integer, null: false
    change_column :versions, :number, :string, null: false
    change_column :test_results, :result, :boolean, null: false
  end

  def self.down
    change_column :test_results, :version_id, :integer, null: true
    change_column :test_results, :rubygem_id, :integer, null: true
    change_column :rubygems, :name, :string, null: true
    change_column :versions, :rubygem_id, :integer, null: true
    change_column :versions, :number, :string, null: true
    change_column :test_results, :result, :boolean, null: true
  end
end

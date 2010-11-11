class CreateTestResults < ActiveRecord::Migration
  def self.up
    create_table :test_results do |t|
      t.integer :architecture_id
      t.integer :vendor_id
      t.integer :operating_system_id
      t.integer :machine_architecture_id
      t.string :name
      t.string :version
      t.boolean :result
      t.text :test_output

      t.timestamps
    end
  end

  def self.down
    drop_table :test_results
  end
end

class CreateArchitectures < ActiveRecord::Migration
  def self.up
    create_table :architectures do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :architectures
  end
end

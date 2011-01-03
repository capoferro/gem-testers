class FixGemVersionIndex < ActiveRecord::Migration
  def self.up
    remove_index :versions, :number
    add_index :versions, [:rubygem_id, :number], unique: true
  end

  def self.down
    remove_index :versions, :number
    add_index :versions, :number, unique: true
  end
end

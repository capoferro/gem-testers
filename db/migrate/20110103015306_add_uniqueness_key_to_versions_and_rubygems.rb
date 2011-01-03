class AddUniquenessKeyToVersionsAndRubygems < ActiveRecord::Migration
  def self.up
    add_index :rubygems, :name, unique: true
    add_index :versions, :number, unique: true
  end

  def self.down
    remove_index :rubygems, :name
    remove_index :versions, :number
  end
end

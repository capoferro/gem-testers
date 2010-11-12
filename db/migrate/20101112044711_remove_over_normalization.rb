class RemoveOverNormalization < ActiveRecord::Migration
  def self.up
    ['operating_system', 'architecture', 'machine_architecture', 'vendor'].each do |thing|
      remove_column :test_results, "#{thing}_id".to_sym
      add_column :test_results, thing.to_sym, :string
    end
  end

  def self.down
    [:operating_systems, :architectures, :machine_architectures, :vendors].each do |thing|
      add_column :test_results, "#{thing}_id".to_sym, :string
      remove_column :test_results, thing
    end
  end
end

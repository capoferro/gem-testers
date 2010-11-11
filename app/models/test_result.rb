class TestResult < ActiveRecord::Base

  alias_attribute :arch, :architecture
  alias_attribute :os, :operating_system
  alias_attribute :machine_arch, :machine_architecture

  serialize :version, Gem::Version
  
  belongs_to :architecture
  belongs_to :vendor
  belongs_to :operating_system
  belongs_to :machine_architecture

  def self.new_from_yaml attributes
    new(self::fetch_associations(attributes))
  end

end

class TestResult < ActiveRecord::Base

  alias_attribute :arch, :architecture
  alias_attribute :os, :operating_system
  alias_attribute :machine_arch, :machine_architecture
  
  belongs_to :rubygem
  belongs_to :version
end

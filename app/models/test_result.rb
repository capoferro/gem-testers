class TestResult < ActiveRecord::Base

  validates_presence_of :rubygem_id, :version_id, :result
  
  belongs_to :rubygem
  belongs_to :version
end

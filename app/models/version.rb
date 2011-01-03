class Version < ActiveRecord::Base

  has_many :test_results
  belongs_to :rubygem

  validates_uniqueness_of :number, scope: [:rubygem_id]
  
end

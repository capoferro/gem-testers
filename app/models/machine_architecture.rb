class MachineArchitecture < ActiveRecord::Base

  has_many :test_results

  validates_uniqueness_of :name  

end

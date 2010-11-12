class Version < ActiveRecord::Base

  has_many :test_results
  belongs_to :rubygem
  
end

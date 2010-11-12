class Rubygem < ActiveRecord::Base

  has_many :test_results
  has_many :versions

end

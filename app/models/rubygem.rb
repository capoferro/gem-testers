class Rubygem < ActiveRecord::Base

  validates_uniqueness_of :name

  has_many :test_results
  has_many :versions

end

class Rubygem < ActiveRecord::Base

  # routes can't include ^/$ in a constraint
  ROUTE_MATCHER = /[A-Za-z0-9\-\_\.]+/
  NAME_MATCHER = /^#{ROUTE_MATCHER}$/
  
  validates_uniqueness_of :name
  validates_format_of :name, with: NAME_MATCHER

  has_many :test_results
  has_many :versions

end

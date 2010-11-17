class TestResult < ActiveRecord::Base

  belongs_to :rubygem
  belongs_to :version

end

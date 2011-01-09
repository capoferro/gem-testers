class TestResult < ActiveRecord::Base

  validates_presence_of :rubygem_id, :version_id
  validates_inclusion_of :result, in: [true, false], message: 'must be true or false'
  
  belongs_to :rubygem
  belongs_to :version

  def simple_attributes
    attrs = self.attributes.clone
    attrs.delete :test_results
    attrs
  end
end

class TestResult < ActiveRecord::Base

  validates_presence_of :rubygem_id, :version_id
  validates_inclusion_of :result, in: [true, false], message: 'must be true or false'
  
  belongs_to :rubygem
  belongs_to :version

  def short_attributes options={with_associations: true}
    attrs = self.attributes.clone
    attrs.delete 'test_output'
    if options[:with_associations]
      attrs['rubygem'] = self.rubygem.attributes
      attrs['version'] = self.version.attributes
    end
    attrs
  end
end

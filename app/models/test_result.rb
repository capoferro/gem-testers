class TestResult < ActiveRecord::Base

  DATATABLES_COLUMNS = ['result', 'versions.number', 'platform', 'ruby_version', 'operating_system', 'architecture', 'vendor'].freeze

  include Rails.application.routes.url_helpers
  
  validates_presence_of :rubygem_id, :version_id
  validates_inclusion_of :result, in: [true, false], message: 'must be true or false'

  scope :matching, -> search_term do
    search_args = []
    search = ''
    if 'pass' =~ /#{search_term}/
      search_args << true
      search += 'result = ? OR '
    end
    
    if 'fail' =~ /#{search_term}/
      search_args << false
      search += 'result = ? OR '
    end

    search += DATATABLES_COLUMNS[1..-1].join(' LIKE ? OR ') + ' LIKE ?'
    (DATATABLES_COLUMNS.size - 1).times { search_args << "%#{search_term}%" }

    search_args.unshift search
    
    includes(:version).where(*search_args)
  end
  
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

  def datatables_attributes
    humanized_result = "<a href=\"#{rubygem_version_test_result_path(self.rubygem.name, self.version.number, self)}\">"
    humanized_result += if self.result
                          '<div class="datatable-cell grade pass">PASS</div></a>'
                        else
                          '<div class="datatable-cell grade fail">FAIL</div>'
                        end
    humanized_result += "</a>"
    [humanized_result].concat [self.version.number, self.platform, self.ruby_version, self.operating_system, self.architecture, self.vendor].collect {|x| "<div class=\"datatable-cell\">#{x}</div>"}
  end

end

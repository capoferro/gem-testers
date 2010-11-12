require 'spec_helper'

describe TestResult do
  
  before do
    @valid_attributes = {
      :architecture => 'somearch',
      :vendor => 'somevendor',
      :operating_system => 'someos',
      :machine_architecture => 'somemacharch',
      :result => true,
      :test_output => "This is some test output. It's text and it's useful.",
      :version_id => 1,
      :rubygem_id => 1
    }
  end

  it "should accept valid attributes to create a new object" do
    TestResult.create! @valid_attributes
  end

end

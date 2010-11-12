require 'spec_helper'

describe Version do
  before do
    @valid_attributes = {
      :number => '1.0.0.0',
      :rubygem_id => 1
    }
  end

  it "should accept valid attributes to create a new object" do
    Version.create! @valid_attributes
  end
end

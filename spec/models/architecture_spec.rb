require 'spec_helper'

describe Architecture do
  
  before do
    @valid_attributes = {:name => 'architecturename'}
  end

  it "should accept valid attributes to create a new object" do
    Architecture.create! @valid_attributes
  end
  
end

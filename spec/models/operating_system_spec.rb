require 'spec_helper'

describe OperatingSystem do
  before do
    @valid_attributes = {:name => 'operatingsystemname'}
  end

  it "should accept valid attributes to create a new object" do
    OperatingSystem.create! @valid_attributes
  end
end

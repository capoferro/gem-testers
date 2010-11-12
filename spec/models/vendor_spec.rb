require 'spec_helper'

describe Vendor do
  before do
    @valid_attributes = {:name => 'vendorname'}
  end

  it "should accept valid attributes to create a new object" do
    Vendor.create! @valid_attributes
  end
end

require 'spec_helper'

describe MachineArchitecture do

  before do
    @valid_attributes = {:name => 'machinearchitecturename'}
  end

  it "should accept valid attributes to create a new object" do
    MachineArchitecture.create! @valid_attributes
  end

end

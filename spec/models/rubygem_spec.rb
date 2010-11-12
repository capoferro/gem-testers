require 'spec_helper'

describe Rubygem do
  before do
    @valid_attributes = {:name => 'rubygemname'}
  end

  it "should accept valid attributes to create a new object" do
    Rubygem.create! @valid_attributes
  end
end

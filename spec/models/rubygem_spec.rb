require 'spec_helper'

describe Rubygem do
  before do
    @valid_attributes = {name: 'rubygemname'}
  end

  it "should accept valid attributes to create a new object" do
    Rubygem.create! @valid_attributes
  end

  it 'should not allow more than one gem with the same name' do
    Factory.create :rubygem, name: 'gemname'
    g = Factory.build :rubygem, name: 'gemname'
    g.save.should be_false
  end
end

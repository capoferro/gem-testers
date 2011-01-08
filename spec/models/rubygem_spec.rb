require 'spec_helper'

describe Rubygem do
  it "should accept valid attributes to create a new object" do
    Factory.create :rubygem
  end

  it 'should not allow more than one gem with the same name' do
    Factory.create :rubygem, name: 'gemname'
    g = Factory.build :rubygem, name: 'gemname'
    g.save.should be_false
  end

  it 'should not allow a rubygem without a name' do
    g = Factory.build :rubygem, name: nil
    g.save.should be_false
  end

  it 'should not allow a rubygem with an empty name' do
    g = Factory.build :rubygem, name: ''
    g.save.should be_false
  end

  ['^%@', 'Abc$@'].each do |name|
    it "should not allow a rubygem with an invalid name: #{name}" do
      g = Factory.build :rubygem, name: name
      g.save.should be_false
    end
  end
end

require 'spec_helper'

describe TestResult do

  it "should accept valid attributes to create a new object" do
    t = Factory.build :test_result
    t.save.should be_true
  end

  it "should not accept test results without a proper gem id" do
    t = Factory.build :test_result, rubygem_id: nil
    t.save.should be_false
  end

  it "should not accept test results without a proper version id" do
    t = Factory.build :test_result, version_id: nil
    t.save.should be_false
  end

  it "should not accept test results without a declaration of pass/fail" do
    t = Factory.build :test_result, result: nil
    t.save.should be_false
  end

  it "should allow false test results" do
    t = Factory.build :test_result, result: false
    t.save.should be_true
  end

  it "should supply test results without test output, with associations" do
    g = Factory.build :rubygem
    v = Factory.build :version, rubygem: g
    t = Factory.build :test_result, rubygem: g, version: v
    attrs = t.short_attributes
    attrs['test_output'].should be_nil
    attrs['rubygem'].should == g.attributes
    attrs['version'].should == v.attributes
  end

  it "should supply test results without test output, without associations" do
    g = Factory.build :rubygem
    v = Factory.build :version, rubygem: g
    t = Factory.build :test_result, rubygem: g, version: v
    attrs = t.short_attributes with_associations: false
    attrs['test_output'].should be_nil
    attrs['rubygem'].should be_nil
    attrs['version'].should be_nil
  end

end

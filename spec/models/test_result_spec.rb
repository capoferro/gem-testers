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

  it "should supply abbreviated test results" do
    t = Factory.build :test_result
    attrs = t.attributes
    attrs.delete :test_output
    t.simple_attributes.should == attrs
  end

end

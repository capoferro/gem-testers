require 'spec_helper'

describe TestResult do

  before do
    @g = Factory.create :rubygem
    @v = Factory.create :version, rubygem: @g
    @t = Factory.build :test_result, version: @v, rubygem: @g
  end

  it "should give attributes in datatables format" do
    @t.save!
    @t.datatables_attributes.should == ["<a href=\"/gems/ruby1stgem/v/1.0.0.0/test_results/1\"><div class=\"datatable-cell grade pass\">PASS</div></a></a>",
                                        "<div class=\"datatable-cell\">1.0.0.0</div>",
                                        "<div class=\"datatable-cell\">someplatform</div>",
                                        "<div class=\"datatable-cell\">3.0.0</div>",
                                        "<div class=\"datatable-cell\">Linux</div>",
                                        "<div class=\"datatable-cell\">somearch</div>",
                                        "<div class=\"datatable-cell\">somevendor</div>"]
  end
  
  it "should accept valid attributes to create a new object" do
    @t.save.should be_true
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
    attrs = @t.short_attributes
    attrs['test_output'].should be_nil
    attrs['rubygem'].should == @g.attributes
    attrs['version'].should == @v.attributes
  end

  it "should supply test results without test output, without associations" do
    attrs = @t.short_attributes with_associations: false
    attrs['test_output'].should be_nil
    attrs['rubygem'].should be_nil
    attrs['version'].should be_nil
  end

  describe 'should search for' do
    it "passing results" do
      Factory.create :test_result, result: false
      Factory.create :test_result, result: true

      t = TestResult.matching('pass')
      t.size.should == 1
      r = t.first
      r.result.should == true
    end
    
    it "failing results" do
      Factory.create :test_result, result: false
      Factory.create :test_result, result: true

      t = TestResult.matching('fail')
      t.size.should == 1
      r = t.first
      r.result.should == false
    end

    it "os results" do
      Factory.create :test_result, operating_system: 'Linux'
      Factory.create :test_result, operating_system: 'something else'

      t = TestResult.matching('Li')
      t.size.should == 1
      r = t.first
      r.operating_system.should == 'Linux'
    end
  end
end

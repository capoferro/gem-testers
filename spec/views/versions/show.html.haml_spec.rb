require 'spec_helper'

describe "versions/show.html.haml" do
  before(:each) do
    @gem = Factory.create :rubygem
    assign(:ruby_versions, [])
    assign(:operating_systems, [])
    assign(:platform, nil)
    assign(:rubygem, @gem)
  end

  it "should display a prerelease badge when version tested is a prerelease" do
    @version = Factory.create :version, rubygem: @gem, prerelease: true
    @result = Factory.create :test_result, version: @version, rubygem: @gem
    assign(:result, @result)
    assign(:version, @version)
    assign(:all_test_results, [@result])
    assign(:test_results, [@result])          

    render

    rendered.should match(/prerelease/)
  end
  
  it "should not display a prerelease badge when version tested is full release" do
    @version = Factory.create :version, rubygem: @gem, prerelease: false
    @result = Factory.create :test_result, version: @version, rubygem: @gem
    assign(:result, @result)
    assign(:version, @version)
    assign(:all_test_results, [@result])
    assign(:test_results, [@result])

    render

    rendered.should_not match(/prerelease/)
  end
end


require 'spec_helper'

describe "test_results/show.html.haml" do
  before(:each) do
    @gem = Factory.create :rubygem
  end

  it "should display a prerelease badge when version tested is a prerelease" do
    @version = Factory.create :version, rubygem: @gem, prerelease: true
    @result = Factory.create :test_result, version: @version, rubygem: @gem
    assign(:result, @result)

    render

    rendered.should match(/prerelease/)
  end
  
  it "should not display a prerelease badge when version tested is full release" do
    @version = Factory.create :version, rubygem: @gem, prerelease: false
    @result = Factory.create :test_result, version: @version, rubygem: @gem
    assign(:result, @result)

    render

    rendered.should_not match(/prerelease/)
  end
end


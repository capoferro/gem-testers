require 'spec_helper'

describe RubygemsController do

  it 'should #show successfully' do
    r = Factory.create :rubygem
    v = Factory.create :version, rubygem_id: r
    tr = Factory.create :test_result, rubygem_id: r.id, version_id: v.id
    get :show, id: r.name
    response.should be_successful
  end

  it "should redirect if there are no test results" do
    r = Factory.create :rubygem
    get :show, id: r.name
    response.should be_redirect
  end

  it 'should route to the root url when showing a gem that does not exist' do
    get :show, id: 'foo'
    response.should be_redirect
    flash[:notice].should == "Couldn't find that gem!"
    response.should redirect_to root_path 
  end

  it 'should respond to json requests' do
    gem = Factory.create :rubygem, name: 'foo'
    v = Factory.create :version, number: '1.0.0', rubygem_id: gem.id
    10.times { Factory.create :test_result, rubygem_id: gem.id, version_id: v.id }
      
    get :show, id: gem.name, format: 'json'
    response.should be_success
    response.body.should == gem.to_json(include: { versions: {include: :test_results} } )

  end

  it 'should be successful when the rubygem is not found' do
    get :show, id: 'somegem', format: 'json'
    response.should be_success
    response.body.should == '{}'
  end

  it 'should respond to #index.json' do
    get :index, format: 'json'
    response.should be_success
    response.body.should == '{"pass_count":0,"fail_count":0,"test_results":[]}'
  end

  it 'should include total pass/fail counts with rubygems' do
    gem = Factory.create :rubygem, name: 'foo'
    v = Factory.create :version, number: '1.0.0', rubygem_id: gem.id
    Factory.create :test_result, rubygem_id: gem.id, version_id: v.id
    gem2 = Factory.create :rubygem, name: 'fooble'
    v2 = Factory.create :version, number: '1.0.0', rubygem_id: gem2.id
    Factory.create :test_result, rubygem_id: gem2.id, version_id: v2.id, result: false
    Factory.create :test_result, rubygem_id: gem2.id, version_id: v2.id

    get :index, format: 'json'
    
    response.body.should == {pass_count: 2, fail_count: 1, test_results: TestResult.order('created_at DESC').all.collect(&:simple_attributes)}.to_json
  end

  describe "When there is a platform parameter" do
    render_views 

    before(:each) do
      @r = Factory.create :rubygem
      10.times do 
        v = Factory.create :version, rubygem: @r
        Factory.create :test_result, version: v, rubygem: @r, platform: "ruby" 
        Factory.create :test_result, version: v, rubygem: @r, platform: "jruby" 
      end
      
      @r2 = Factory.create :rubygem
      @v2 = Factory.create :version, rubygem: @r2
      Factory.create :test_result, version: @v2, rubygem: @r2, platform: "jruby" 
    end

    it "should #show if there are tests for that platform" do
      get :show, id: @r.name, platform: "ruby"
      response.should be_successful
    end
    
    it "should not omit valid platforms if one is selected" do
      get :show, id: @r.name, platform: "ruby"
      response.should be_successful
      response.body.should match(%r!<option[^>]*>jruby</option>!)
    end

    it "should redirect if there are no tests for that platform" do
      get :show, id: @r.name, platform: "rbx"
      response.should be_redirect
    end
    
    it "should have the right platform selected when there is only one platform" do
      get :show, id: @r.name, platform: "jruby"
      response.should be_success
      response.body.should match(%r!<option value="[^"]+" selected="selected">jruby</option>!i)
    end
  end
end

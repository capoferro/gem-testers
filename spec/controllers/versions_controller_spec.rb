require 'spec_helper'

describe VersionsController do
  describe '' do
    render_views
    it 'should redirect #show with no test results' do
      r = Factory.create :rubygem
      v = Factory.create :version, rubygem_id: r.id
      get :show, rubygem_id: r.name, id: v.number
      
      response.body.should match(/Nothing to see here!/)
    end
  end
  it 'should redirect to rubygems#index when rubygem not found' do
    get :show, rubygem_id: 'doesntexist', id: 'doesntmatter'
    
    response.should redirect_to rubygems_path
  end
  
  it 'should redirect to all versions if the version doesn\'t exist' do
    r = Factory.create :rubygem
    get :show, rubygem_id: r.name, id: 'doesntexist'
    response.should redirect_to rubygem_path(r.name)
  end

  it 'should redirect when receiving #index' do
    get :index, rubygem_id: 'gem'
    response.should redirect_to rubygem_path('gem')
  end

  it 'should be successful when getting json and version is not found' do
    r = Factory.create :rubygem
    get :show, rubygem_id: r.name, id: '1.0.0.random.json'
    response.should be_successful
    response.body.should == '{}'
  end 

  describe "When there are test results" do
    before(:each) do
      @r = Factory.create :rubygem
      @v = Factory.create :version, rubygem: @r
      10.times { Factory.create :test_result, version: @v, rubygem: @r }
    end

    it 'should respond to json format' do
      get :show, rubygem_id: @r.name, id: @v.number + '.json'
      response.body.should == @v.to_json(methods: [:pass_count, :fail_count], include: :test_results)
    end

    it 'should #show successfully' do
      get :show, rubygem_id: @r.name, id: @v.number
      response.should be_successful
    end
  end

  describe "When there is a platform parameter" do
    render_views
  
    before(:each) do
      @r = Factory.create :rubygem
      @v = Factory.create :version, rubygem: @r
      @v2 = Factory.create :version, rubygem: @r
      10.times { Factory.create :test_result, version: @v, rubygem: @r, platform: "ruby" }
      10.times { Factory.create :test_result, version: @v, rubygem: @r, platform: "jruby" }
      10.times { Factory.create :test_result, version: @v2, rubygem: @r, platform: "jruby" }
    end

    it "should #show if there are tests for that platform" do
      get :show, rubygem_id: @r.name, id: @v.number, platform: "ruby"
      response.should be_successful
      response.body.should match(%r!<option[^>]*>jruby</option>!)
      response.body.should match(%r!<option[^>]*>ruby</option>!)
    end

    it "should not omit valid platforms if one is selected" do
      get :show, rubygem_id: @r.name, id: @v.number, platform: "ruby"
      response.should be_successful
      response.body.should match(%r!<option[^>]*>jruby</option>!)
    end

    it "should redirect if there are no tests for that platform" do
      get :show, rubygem_id: @r.name, id: @v.number, platform: "rbx"
      response.body.should match(/Nothing to see here!/)
    end

    it "should have the right platform selected when there is only one platform" do
      get :show, rubygem_id: @r.name, id: @v2.number, platform: "jruby"
      response.should be_success
      response.body.should match(%r!<option value="[^"]+" selected="selected">jruby</option>!i)
    end
  end
end

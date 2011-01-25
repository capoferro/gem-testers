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

  describe "When there is a platform parameter" do
    render_views 

    before do
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
      response.body.should match(%r!<option value="[^\"]+" selected="selected">jruby</option>!i)
    end

    it "should handle datatables splatter of parameters with show_paged" do
      g = Factory.create :rubygem
      v = Factory.create :version, rubygem: g
      t = Array.new(20).collect { |x| Factory.create :test_result, version: v, rubygem: g }
      expected_response = { iTotalRecords: 20, iTotalDisplayRecords: 20, aaData: t.slice(10..20).collect(&:datatables_attributes) }.to_json
      get :show_paged, {
        "rubygem_id"=> g.name,
        "format"=>"json",
        "_"=>"1295929530358",
        "sEcho"=>"3",
        "iColumns"=>"7",
        "sColumns"=>"",
        "iDisplayStart"=>"0",
        "iDisplayLength"=>"10",
        "sNames"=>",,,,,,",
        "sSearch"=>"",
        "bRegex"=>"false",
        "sSearch_0"=>"",
        "bRegex_0"=>"false",
        "bSearchable_0"=>"true",
        "sSearch_1"=>"",
        "bRegex_1"=>"false",
        "bSearchable_1"=>"true",
        "sSearch_2"=>"",
        "bRegex_2"=>"false",
        "bSearchable_2"=>"true",
        "sSearch_3"=>"",
        "bRegex_3"=>"false",
        "bSearchable_3"=>"true",
        "sSearch_4"=>"",
        "bRegex_4"=>"false",
        "bSearchable_4"=>"true",
        "sSearch_5"=>"",
        "bRegex_5"=>"false",
        "bSearchable_5"=>"true",
        "sSearch_6"=>"",
        "bRegex_6"=>"false",
        "bSearchable_6"=>"true",
        "iSortingCols"=>"1",
        "iSortCol_0"=>"0",
        "sSortDir_0"=>"asc",
        "bSortable_0"=>"true",
        "bSortable_1"=>"true",
        "bSortable_2"=>"true",
        "bSortable_3"=>"true",
        "bSortable_4"=>"true",
        "bSortable_5"=>"true",
        "bSortable_6"=>"true"}
      response.should be_successful
      response.body.should == expected_response
    end
  end
end

require 'spec_helper'

describe RubygemsController do
  before do
    @g = Factory.create :rubygem
    @v = Factory.create :version, rubygem: @g
  end
  
  it 'should #show successfully' do
    tr = Factory.create :test_result, rubygem_id: @g.id, version_id: @v.id
    get :show, id: @g.name
    response.should be_successful
  end

  describe '' do
    render_views
    it "should redirect if there are no test results" do
      get :show, id: @g.name
      response.body.should match(/Nothing to see here!/)
    end
  end

  it 'should route to the root url when showing a gem that does not exist' do
    get :show, id: 'foo'
    response.should be_redirect
    flash[:notice].should == "Sorry, there's no data for foo yet."
    response.should redirect_to root_path 
  end

  it 'should respond to json requests' do
    10.times { Factory.create :test_result, rubygem_id: @g.id, version_id: @v.id }
    
    get :show, id: @g.name, format: 'json'
    response.should be_success
    response.body.should == @g.to_json(methods: [:pass_count, :fail_count], include: { versions: {methods: [:pass_count, :fail_count], include: :test_results} } )
  end

  it 'should be successful when the rubygem is not found' do
    get :show, id: 'somegem', format: 'json'
    response.should be_success
    response.body.should == '{}'
  end
  
  describe "When there is a platform parameter" do
    render_views 

    before do
      10.times do 
        v = Factory.create :version, rubygem: @g
        Factory.create :test_result, version: v, rubygem: @g, platform: "ruby" 
        Factory.create :test_result, version: v, rubygem: @g, platform: "jruby" 
      end
      
      @g2 = Factory.create :rubygem
      @v2 = Factory.create :version, rubygem: @g2
      Factory.create :test_result, version: @v2, rubygem: @g2, platform: "jruby" 
    end

    it "should #show if there are tests for that platform" do
      get :show, id: @g.name, platform: "ruby"
      response.should be_successful
    end
    
    it "should not omit valid platforms if one is selected" do
      get :show, id: @g.name, platform: "ruby"
      response.should be_successful
      response.body.should match(%r!<option[^>]*>jruby</option>!)
    end

    it "should redirect if there are no tests for that platform" do
      get :show, id: @g.name, platform: "rbx"
      response.body.should match(/Nothing to see here!/)
    end
    
    it "should have the right platform selected when there is only one platform" do
      get :show, id: @g.name, platform: "jruby"
      response.should be_success
      response.body.should match(%r!<option value="[^\"]+" selected="selected">jruby</option>!i)
    end
  end

  
  describe "datatables paging" do
    before do
      @datatables_params = {
        "rubygem_id"=> @g.name,
        "format"=>"json",
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
    end
    it "should handle datatables splatter of parameters with show_paged" do
      t = Array.new(20).collect { |x| Factory.create :test_result, version: @v, rubygem: @g }
      expected_response = { iTotalRecords: 20, iTotalDisplayRecords: 20, aaData: t.slice(0..9).collect(&:datatables_attributes) }.to_json
      get :show_paged, @datatables_params
      response.should be_successful
      response.body.should == expected_response
    end

    describe "should search" do
      before do
        @params = @datatables_params.clone
      end
      it 'pass or fail' do
        @params['sSearch'] = 'pass'
        t = Factory.create :test_result, rubygem: @g, version: @v, result: true
        expected_response = {iTotalRecords: 1, iTotalDisplayRecords: 1, aaData: [t.datatables_attributes]}.to_json
        get :show_paged, @params

        response.should be_successful
        response.body.should == expected_response
      end
    end
    
    describe "should honor sorting in for" do
      before do
        @params = @datatables_params.clone
      end
      
      describe "result" do
        it "ascending" do
          @params['iSortCol_0'] = 0
          @params['sSortDir_0'] = 'asc'
          Array.new(5).collect { |x| Factory.create :test_result, result: true, version: @v, rubygem: @g }
          Array.new(5).collect { |x| Factory.create :test_result, result: false, version: @v, rubygem: @g }
          Array.new(3).collect { |x| Factory.create :test_result, result: true, version: @v, rubygem: @g }
          get :show_paged, @params
          r = JSON::parse response.body
          r['aaData'].slice(0..4).collect { |x| x[0].should match(/FAIL/) }
          r['aaData'].slice(5..12).collect { |x| x[0].should match(/PASS/) }
        end
        
        it "descending" do
          @params['iSortCol_0'] = 0
          @params['sSortDir_0'] = 'desc'
          Array.new(5).collect { |x| Factory.create :test_result, result: true, version: @v, rubygem: @g }
          Array.new(5).collect { |x| Factory.create :test_result, result: false, version: @v, rubygem: @g }
          Array.new(3).collect { |x| Factory.create :test_result, result: true, version: @v, rubygem: @g }
          get :show_paged, @params
          r = JSON::parse response.body
          r['aaData'].slice(0..7).collect { |x| x[0].should match(/PASS/) }
          r['aaData'].slice(8..12).collect { |x| x[0].should match(/FAIL/) }
        end
        
      end
      describe "gem version" do


        it "ascending" do
          @params['iSortCol_0'] = 1
          @params['sSortDir_0'] = 'asc'
          v1 = Factory.create :version, number: '0.1.0'
          v3 = Factory.create :version, number: '1.2.0'
          v2 = Factory.create :version, number: '0.2.0'
          Array.new(5).collect { |x| Factory.create :test_result, result: true, version: v1, rubygem: @g }
          Array.new(5).collect { |x| Factory.create :test_result, result: false, version: v3, rubygem: @g }
          Array.new(3).collect { |x| Factory.create :test_result, result: true, version: v2, rubygem: @g }
          get :show_paged, @params
          r = JSON::parse response.body
          r['aaData'].slice(0..4).collect { |x| x[1].should match(/0.1.0/) }
          r['aaData'].slice(5..7).collect { |x| x[1].should match(/0.2.0/) }
          r['aaData'].slice(8..9).collect { |x| x[1].should match(/1.2.0/) }
        end
        
        it "descending" do
          @params['iSortCol_0'] = 1
          @params['sSortDir_0'] = 'desc'
          v1 = Factory.create :version, number: '0.1.0'
          v3 = Factory.create :version, number: '1.2.0'
          v2 = Factory.create :version, number: '0.2.0'
          Array.new(5).collect { |x| Factory.create :test_result, result: true, version: v1, rubygem: @g }
          Array.new(5).collect { |x| Factory.create :test_result, result: false, version: v3, rubygem: @g }
          Array.new(3).collect { |x| Factory.create :test_result, result: true, version: v2, rubygem: @g }
          get :show_paged, @params
          r = JSON::parse response.body
          r['aaData'].slice(0..4).collect { |x| x[1].should match(/1.2.0/) }
          r['aaData'].slice(5..7).collect { |x| x[1].should match(/0.2.0/) }
          r['aaData'].slice(8..10).collect { |x| x[1].should match(/0.1.0/) }
        end
      end
    end
  end
end

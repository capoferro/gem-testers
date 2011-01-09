require 'spec_helper'

describe RubygemsController do

  it 'should #show successfully' do
    Factory.create :rubygem, name: 'gem'
    get :show, id: 'gem'
    response.should be_successful
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
    1.times { Factory.create :test_result, rubygem_id: gem.id, version_id: v.id }
    gem2 = Factory.create :rubygem, name: 'fooble'
    v2 = Factory.create :version, number: '1.0.0', rubygem_id: gem2.id
    1.times { Factory.create :test_result, rubygem_id: gem2.id, version_id: v2.id, result: false }
    1.times { Factory.create :test_result, rubygem_id: gem2.id, version_id: v2.id }

    get :index, format: 'json'
    
    response.body.should == {pass_count: 2, fail_count: 1, test_results: TestResult.order('created_at DESC').all.collect(&:simple_attributes)}.to_json
  end
end

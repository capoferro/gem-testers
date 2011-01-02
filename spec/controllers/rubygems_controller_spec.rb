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

  it 'should allow results to be filtered for passing results' do
    gem = Factory.create :rubygem, name: 'somegem'
    v = Factory.create :version, number: '1.0.0', rubygem_id: gem.id
    3.times { Factory.create :test_result, rubygem_id: gem.id, version_id: v.id, result: false }
    2.times { Factory.create :test_result, rubygem_id: gem.id, version_id: v.id, result: true }
    get :show, rubygem_id: 'somegem', filter: 'pass'
    assigns(:test_results).length.should == 2
  end
  
  it 'should allow results to be filtered for failing results' do
    gem = Factory.create :rubygem, name: 'somegem'
    v = Factory.create :version, number: '1.0.0', rubygem_id: gem.id
    3.times { Factory.create :test_result, rubygem_id: gem.id, version_id: v.id, result: false }
    2.times { Factory.create :test_result, rubygem_id: gem.id, version_id: v.id, result: true }
    get :show, rubygem_id: 'somegem', filter: 'fail'
    assigns(:test_results).length.should == 3
  end

  it 'should allow results to be filtered for passing results as json' do
    gem = Factory.create :rubygem, name: 'somegem'
    v = Factory.create :version, number: '1.0.0', rubygem_id: gem.id
    3.times { Factory.create :test_result, rubygem_id: gem.id, version_id: v.id, result: false }
    #2.times { Factory.create :test_result, rubygem_id: gem.id, version_id: v.id, result: true }
    get :show, rubygem_id: 'somegem', filter: 'pass', format: 'json'
    response.body.should == 'something'
  end
  
  it 'should allow results to be filtered for failing results as json' do
    gem = Factory.create :rubygem, name: 'somegem'
    v = Factory.create :version, number: '1.0.0', rubygem_id: gem.id
   # 3.times { Factory.create :test_result, rubygem_id: gem.id, version_id: v.id, result: false }
    2.times { Factory.create :test_result, rubygem_id: gem.id, version_id: v.id, result: true }
    get :show, rubygem_id: 'somegem', filter: 'fail', format: 'json'
    response.body.should == 'something'
  end
end

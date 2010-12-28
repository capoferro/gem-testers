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
    flash[:notice].should == "That gem does not exist"
    response.should redirect_to root_path 
  end

  it 'should respond to json requests' do
    gem = Factory.create :rubygem, name: 'foo'
    v = Factory.create :version, number: '1.0.0', rubygem_id: gem.id
    10.times { Factory.create :test_result, rubygem_id: gem.id, version_id: v.id }
      
    get :show, id: 'foo', format: 'json'
    response.should be_success
    response.body.should == gem.to_json(include: { versions: {include: :test_results} } )

  end
end

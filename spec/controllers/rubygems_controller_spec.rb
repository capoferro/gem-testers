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
end

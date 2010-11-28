require 'spec_helper'

describe RubygemsController do

  it 'should #show successfully' do
    Factory.create :rubygem, name: 'gem'
    get :show, id: 'gem'
    response.should be_successful
  end

end

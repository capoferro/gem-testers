require 'spec_helper'

describe 'test results routing' do
  it 'should route POST /test_results' do
    { :post => '/test_results' }.should route_to(:controller => 'test_results',
                                                 :action => 'create')
  end

end

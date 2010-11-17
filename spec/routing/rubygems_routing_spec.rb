require 'spec_helper'

describe 'Rubgems routing' do
  
  it 'should route to platform_overlay' do
    
    { :get => '/rubygems/123/platform_overlay' }.should route_to(:controller => 'rubygems',
                                                                 :action => 'platform_overlay',
                                                                 :id => '123')
    
  end
  
end

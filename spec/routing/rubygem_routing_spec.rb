require 'spec_helper'

describe 'Rubygem routing' do
  it 'should route to rubygems#index' do
    { :get => '/' }.should route_to(:controller => 'rubygems',
                                    :action => 'index')
  end

  ['thegem', 'the-gem',  'THEgem', '-thegem', 'thegem-'].each do |gemname| # TODO: gems with `.`
    it "should route to rubygems#show for #{gemname}" do
      { :get => "/gems/#{gemname}" }.should route_to(:controller => 'rubygems',
                                                     :action => 'show',
                                                     :id => gemname)
    end
  end

  it "should route to rubygems#browse" do
    { get: '/gems/browse' }.should route_to(controller: 'rubygems',
                                            action: 'browse')
  end
end

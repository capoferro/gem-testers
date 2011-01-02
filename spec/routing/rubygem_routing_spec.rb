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

    it "should route to rubygems#show.json for #{gemname}" do
      { :get => "/gems/#{gemname}.json" }.should route_to(:controller => 'rubygems',
                                                          :action => 'show',
                                                          :format => 'json',
                                                          :id => gemname)
    end

    it "should route to rubygems#show with a pass filter for #{gemname}" do
      { get: "/gems/#{gemname}/pass" }.should route_to(controller: 'rubygems',
                                                       action: 'show',
                                                       rubygem_id: gemname,
                                                       filter: 'pass')
    end

    it "should route to rubygems#show with a fail filter for #{gemname}" do
      { get: "/gems/#{gemname}/fail" }.should route_to(controller: 'rubygems',
                                                       action: 'show',
                                                       rubygem_id: gemname,
                                                       filter: 'fail')
    end
    
    it "should route to the rss feed for #{gemname}" do
      { get: "/gems/#{gemname}/feed.xml" }.should route_to(controller: 'rubygems',
                                                           action: 'feed',
                                                           rubygem_id: gemname)
    end
  end

end

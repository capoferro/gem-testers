require 'spec_helper'

describe 'Version routing' do
  
  ['1.0.0', '1.0.0.rc', '1.0.0.beta.22'].each do |version|
    it "should route to versions#show with #{version}" do
      { get: "/gems/somegem/v/#{version}" }.should route_to(controller: 'versions',
                                                               action: 'show',
                                                               rubygem_id: 'somegem',
                                                               id: version)
    end

    # it "should route to versions#show.json with #{version}" do
    #   { get: "/gems/somegem/v/#{version}.json" }.should route_to(controller: 'versions',
    #                                                         action: 'show',
    #                                                         format: 'json',
    #                                                         rubygem_id: 'somegem',
    #                                                         id: version)
    # end
  end
  
end

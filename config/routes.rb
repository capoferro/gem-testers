GemTesters::Application.routes.draw do
  root :to => 'rubygems#index'

  resources :rubygems, :path => 'gems' do
    get "/feed.xml" => 'rubygems#feed', :as => 'feed'

    constraints :id => Rubygem::ROUTE_MATCHER do
      resources :versions, :path => 'v' do
        resources :test_results
      end
    end
  end

  post '/test_results' => 'test_results#create'
end

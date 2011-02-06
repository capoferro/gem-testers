GemTesters::Application.routes.draw do
  root :to => 'rubygems#index'

  resources :rubygems, :path => 'gems' do
    constraints :id => Rubygem::ROUTE_MATCHER do
      get '/feed.xml' => 'rubygems#feed', :as => 'feed'
      get '/paged.:format' => 'rubygems#show_paged', as: 'paged'
      resources :versions, :path => 'v' do
        get '/paged.:format' => 'versions#show_paged', as: 'paged'
        resources :test_results
      end
    end
  end

  post '/test_results' => 'test_results#create'
  get '/test_results.:format' => 'test_results#index', as: 'test_results'
end

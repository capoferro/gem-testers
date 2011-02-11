GemTesters::Application.routes.draw do
  root :to => 'rubygems#index'

  resources :rubygems, path: 'gems' do
    constraints id: Rubygem::ROUTE_MATCHER do
      get '/feed' => 'rubygems#feed', as: 'feed', format: :xml
      get '/paged.:format' => 'rubygems#show_paged', as: 'paged'
      resources :versions, path: 'v' do
        get '/paged' => 'versions#show_paged', as: 'paged', format: :json
        get '/:id' => "versions#show", as: 'show', format: [:html, :json]
        resources :test_results 
      end
    end
  end

  post '/test_results' => 'test_results#create'
  get '/test_results.:format' => 'test_results#index', as: 'test_results'
end

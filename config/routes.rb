RUBYGEM_NAME_MATCHER = /[A-Za-z0-9\-\_\.]+/

GemTesters::Application.routes.draw do
  root :to => 'rubygems#index'

  resources :rubygems, :path => 'gems' do
    constraints :id => RUBYGEM_NAME_MATCHER do
      get '/feed.xml' => 'rubygems#feed', :as => 'feed'
      get '/:filter' => 'rubygems#show', :as => 'filtered'
      resources :versions, :path => 'v' do
        get '/:filter' => 'rubygems#show', :as => 'filtered'
        resources :test_results
      end
    end
  end

  post '/test_results' => 'test_results#create'
end

GemTesters::Application.routes.draw do

  resources :rubygems do
    get 'platform_overlay' => 'rubygems#platform_overlay', :as => 'platform_overlay'
    resources :versions do
      resources :test_results
    end
  end

  
  post '/test_results' => 'test_results#create'

end

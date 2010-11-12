GemTesters::Application.routes.draw do

  resources :rubygems do
    resources :versions do
      resources :test_results
    end
  end


  post '/test_results' => 'test_results#create'

end

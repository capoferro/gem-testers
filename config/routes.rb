GemTesters::Application.routes.draw do

  resource :rubygem do
    resource :version do
      resource :test_result
    end
  end

  post '/test_results' => 'test_results#create'

end

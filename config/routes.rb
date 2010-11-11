GemTesters::Application.routes.draw do
  
  post '/test_results' => 'test_results#create'

end

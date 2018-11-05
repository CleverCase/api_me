Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users
      resources :posts
      resources :fails
      resources :multi_word_resources
    end
  end
end

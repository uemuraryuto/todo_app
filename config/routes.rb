Rails.application.routes.draw do
  root 'tasks#index'
  resources :tasks do
    collection { post :import }
  end
  resources :categories
end

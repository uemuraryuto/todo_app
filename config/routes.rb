Rails.application.routes.draw do
  root 'tasks#index'
  resources :tasks do
    post :import, on: :collection
  end
  resources :categories
end

Rails.application.routes.draw do
  root to: 'home#index'

  devise_for :users

  resources :posts do
    resources :comments 
  end
end

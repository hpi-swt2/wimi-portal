Rails.application.routes.draw do

  root 'dashboard#index'
  get 'dashboard', to: 'dashboard#index'

  resources :publications
  resources :projects
  resources :holidays
  resources :trips
  resources :expenses

  get '/profile', to: 'user_profile#show'
  patch '/profile', to: 'user_profile#update'

  devise_for :users
end

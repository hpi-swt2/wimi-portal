Rails.application.routes.draw do
  resources :trips
  resources :holidays
  resources :expenses
  resources :publications
  resources :projects
  get 'welcome/index'

  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  resources :projects
  resources :users
  resources :holidays
  resources :expenses
  resources :trips
  resources :publications
  
  # You can have the root of your site routed with "root"
  root 'welcome#index'
end

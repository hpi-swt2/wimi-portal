Rails.application.routes.draw do
  get 'dashboard', to: 'dashboard#index'

    # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  resources :publications
  resources :projects
  resources :holidays
  resources :trips
  resources :expenses
  resources :chairs
  
  devise_for :users

  post 'chairs/apply', to: 'chairs#apply'
  post 'chairs/accept', to: 'chairs#accept_request'
  post 'chairs/remove_user', to: 'chairs#remove_from_chair'

  # You can have the root of your site routed with "root"
  root 'dashboard#index'
end

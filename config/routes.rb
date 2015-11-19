Rails.application.routes.draw do
  get 'dashboard', to: 'dashboard#index'

    # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  resources :publications
  resources :projects
  resources :holidays
  resources :trips
  resources :expenses
  
  devise_for :users

  # You can have the root of your site routed with "root"
  root 'welcome#index'
end

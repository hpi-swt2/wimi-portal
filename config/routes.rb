Rails.application.routes.draw do
  resources :projects
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  resources :publications
  resources :trips
  resources :expenses
  resources :projects
  resources :holidays

  devise_for :users

  # You can have the root of your site routed with "root"
  root 'welcome#index'
end

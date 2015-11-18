Rails.application.routes.draw do
    # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  resources :publications
  resources :projects
  resources :holidays
  resources :trips
  resources :expenses
  resources :work_months
  resources :work_days

  devise_for :users

  # You can have the root of your site routed with "root"
  root 'welcome#index'
end

Rails.application.routes.draw do
    # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  resources :publications
  resources :projects
  resources :holidays
  resources :trips
  resources :expenses
  resources :work_days

  devise_for :users

  #!get 'users/:id' => 'users#show', :as => :user
  #!get 'users/:id/edit' => 'users#edit'

  resources :users, :only => [:show, :edit, :update]

  # You can have the root of your site routed with "root"
  root 'welcome#index'
end

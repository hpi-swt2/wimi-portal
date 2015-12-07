Rails.application.routes.draw do
  get 'dashboard', to: 'dashboard#index'
  get 'users/edit_leave', to: 'users#edit_leave'

    # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  resources :publications
  resources :projects
  resources :holidays
  resources :trips
  resources :expenses
  resources :work_days
  resources :time_sheets, :only => [:edit, :update, :delete]

  devise_for :users

  #!get 'users/:id' => 'users#show', :as => :user
  #!get 'users/:id/edit' => 'users#edit'

  resources :users, :only => [:show, :edit, :edit_leave, :update]

  # You can have the root of your site routed with "root"
  root 'dashboard#index'
end

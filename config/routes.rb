Rails.application.routes.draw do

  root 'dashboard#index'
  get 'dashboard', to: 'dashboard#index'
  get 'users/edit_leave', to: 'users#edit_leave'

  resources :publications
  resources :projects
  resources :holidays
  resources :trips
  resources :expenses
  resources :chairs
  
  post 'chairs/apply', to: 'chairs#apply'
  post 'chairs/accept', to: 'chairs#accept_request'
  post 'chairs/remove_user', to: 'chairs#remove_from_chair'
  post 'chairs/destroy', to: 'chairs#destroy'
  post 'chairs/set_admin', to: 'chairs#set_admin'
  post 'chairs/withdraw_admin', to: 'chairs#withdraw_admin'

  get 'chairs/:id/requests' => 'requests#requests', :as => 'requests'

  devise_for :users

  resources :users, :only => [:show, :edit, :edit_leave, :update]

end

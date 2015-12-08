Rails.application.routes.draw do

  root 'dashboard#index'
  get 'dashboard', to: 'dashboard#index'
  get 'users/edit_leave', to: 'users#edit_leave'


    # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  resources :time_sheets
  resources :publications
  resources :projects
  resources :holidays
  resources :trips
  resources :expenses
  resources :work_days

  devise_for :users

  resources :users, :only => [:show, :edit, :edit_leave, :update]

end

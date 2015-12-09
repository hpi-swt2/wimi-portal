Rails.application.routes.draw do

  root 'dashboard#index'
  get 'dashboard', to: 'dashboard#index'
  get 'users/edit_leave', to: 'users#edit_leave'

  resources :publications
  resources :projects
  resources :holidays
  resources :trips
  resources :expenses
  resources :work_days
  resources :time_sheets, :only => [:edit, :update, :delete]

  devise_for :users

  resources :users, :only => [:show, :edit, :edit_leave, :update]

end

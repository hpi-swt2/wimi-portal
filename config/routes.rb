Rails.application.routes.draw do

  root 'dashboard#index'
  get 'dashboard', to: 'dashboard#index'

  resources :publications
  resources :projects
  resources :holidays
  resources :trips
  resources :expenses

  devise_for :users
  resources :users, :only => [:show, :edit, :update]
end

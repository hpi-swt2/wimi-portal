Rails.application.routes.draw do

  root 'dashboard#index'
  get 'dashboard', to: 'dashboard#index'
  get 'users/edit_leave', to: 'users#edit_leave'

  resources :publications
  resources :projects do
    member do
      post 'invite_user'
    end
  end
  resources :holidays
  resources :trips
  resources :expenses

  get '/profile', to: 'user_profile#show'
  patch '/profile', to: 'user_profile#update'

  get 'projects/typeahead/:query' => 'projects#typeahead'

  devise_for :users

  resources :users, :only => [:show, :edit, :edit_leave, :update]

end

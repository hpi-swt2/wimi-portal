Rails.application.routes.draw do

  resources :publications
  resources :projects do
    member do
      post "invite_user"
    end
  end
  resources :holidays
  resources :trips
  resources :expenses

  get '/profile', to: 'user_profile#show'
  patch '/profile', to: 'user_profile#update'

  devise_for :users

  # You can have the root of your site routed with "root"
  root 'welcome#index'
end

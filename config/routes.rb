Rails.application.routes.draw do
  resources :chair_applications
  resources :chairs
    # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  resources :publications
  resources :projects
  resources :holidays
  resources :trips
  resources :expenses
  
  devise_for :users

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  post '/chair_apply_event' => 'chair_applications#create', :as => 'chair_apply_event'
  post '/chair_cancelapp_event' => 'chair_applications#destroy', :as => 'chair_cancelapp_event'
end

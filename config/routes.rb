Rails.application.routes.draw do
  resources :chair_representatives
  resources :chair_admins
  resources :chair_wimis
  resources :chair_applications
  resources :chairs

  resources :expenses
  resources :holidays

  resources :project_applications, only: [:index, :destroy] do
    member do
      get 'accept'
      get 'decline'
      get 'reapply'
    end
    collection do
      post 'apply/project_:id', to: 'project_applications#create', as: 'apply'
    end
  end

  resources :projects
  resources :publications
  resources :trips
  
  devise_for :users

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  post '/chair_apply_event' => 'chair_applications#create', :as => 'chair_apply_event'
  post '/chair_cancelapp_event' => 'chair_applications#destroy', :as => 'chair_cancelapp_event'
  post '/chair_acceptapp_event' => 'chair_wimis#create', :as => 'chair_acceptapp_event'
  post '/chair_declineapp_event' => 'chair_applications#decline', :as => 'chair_declineapp_event'
end

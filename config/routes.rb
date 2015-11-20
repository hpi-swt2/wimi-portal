Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  resources :expenses
  resources :holidays

  resources :project_applications, only: [:create, :index, :destroy] do
    collection do
      post 'create' => 'project_applications#create', as: 'create'
      get 'index'
      get 'destroy', as: 'destroy'
    end
  end

  resources :projects
  resources :publications
  resources :trips
  
  devise_for :users

  # You can have the root of your site routed with "root"
  root 'welcome#index'
end

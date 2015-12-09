Rails.application.routes.draw do
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

  root 'dashboard#index'
  get 'dashboard', to: 'dashboard#index'
  get 'users/edit_leave', to: 'users#edit_leave'

  resources :projects
  resources :publications
  resources :trips

  devise_for :users

  resources :users, :only => [:show, :edit, :edit_leave, :update]

end

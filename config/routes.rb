Rails.application.routes.draw do

  get 'documents/generate_pdf' => 'documents#generate_pdf', as: 'generate_pdf'

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
  resources :expenses
  resources :travel_expense_reports
  resources :trips do
    member do
      get 'download'
    end
  end
  resources :chairs
  
  post 'chairs/apply', to: 'chairs#apply'
  post 'chairs/accept', to: 'chairs#accept_request'
  post 'chairs/remove_user', to: 'chairs#remove_from_chair'
  post 'chairs/destroy', to: 'chairs#destroy'
  post 'chairs/set_admin', to: 'chairs#set_admin'
  post 'chairs/withdraw_admin', to: 'chairs#withdraw_admin'

  get 'chairs/:id/requests' => 'requests#requests', as: 'requests'

  get 'projects/typeahead/:query' => 'projects#typeahead'

  devise_for :users

  resources :users, only: [:show, :edit, :edit_leave, :update]

end

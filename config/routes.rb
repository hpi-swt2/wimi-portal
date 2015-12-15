Rails.application.routes.draw do

  get 'documents/generate_pdf' => 'documents#generate_pdf', :as => 'generate_pdf'

  root 'dashboard#index'
  get 'dashboard', to: 'dashboard#index'
  get 'users/edit_leave', to: 'users#edit_leave'


    # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  resources :publications
  resources :projects do
    member do
      post 'invite_user'
    end
  end
  resources :holidays
  resources :expenses
  resources :work_days
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

  resources :time_sheets, :only => [:edit, :update, :delete]


  get 'projects/typeahead/:query' => 'projects#typeahead'


  devise_for :users

  resources :users, :only => [:show, :edit, :edit_leave, :update]

end

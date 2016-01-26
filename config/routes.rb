Rails.application.routes.draw do
  devise_for :users

  get 'superadmin' => 'users#superadmin_index', as: 'superadmin'

  resources :chair_applications
  resources :chairs

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

  get 'documents/generate_pdf' => 'documents#generate_pdf', as: 'generate_pdf'

  root 'dashboard#index'
  get 'dashboard', to: 'dashboard#index'
  get 'users/edit_leave', to: 'users#edit_leave'
  get 'users/language', to: 'users#language'

  resources :projects do
    member do
      post 'invite_user'
      get 'accept_invitation'
      get 'decline_invitation'
    end
  end

  resources :projects do
    member do
      get 'toggle_status'
      delete 'sign_user_out/:user_id', action: 'sign_user_out', as: 'sign_user_out'
    end
  end

  get 'projects/typeahead/:query' => 'projects#typeahead'

  resources :holidays do
    member do
      get 'file'
      get 'accept'
      get 'reject'
    end
    get 'holidays/file', to: 'holidays#file'
    get 'holidays/accept', to: 'holidays#accept'
    get 'holidays/reject', to: 'holidays#reject'
  end

  resources :expenses
  resources :work_days
  resources :time_sheets, only: [:edit, :update, :delete, :reject, :hand_in, :accept] do
    member do
      get 'reject'
      get 'hand_in'
      get 'accept'
    end
    get 'time_sheets/reject', to: 'time_sheets#reject'
    get 'time_sheets/hand_in', to:'time_sheets#hand_in'
    get 'time_sheets/accept', to:'time_sheets#accept'
  end

  resources :travel_expense_reports
  
  resources :trips do
    member do
      get 'download'
      get 'file'
      get 'reject'
      get 'accept'
    end
    get 'trips/file', to: 'trips#file'
    get 'trips/reject', to: 'trips#reject'
    get 'trips/accept', to: 'trips#accept'
  end

  resources :chairs

  post 'chairs/apply', to: 'chairs#apply'
  post 'chairs/accept', to: 'chairs#accept_request'
  post 'chairs/remove_user', to: 'chairs#remove_from_chair'
  post 'chairs/destroy', to: 'chairs#destroy'
  post 'chairs/set_admin', to: 'chairs#set_admin'
  post 'chairs/withdraw_admin', to: 'chairs#withdraw_admin'
  get 'chairs/:id/requests' => 'chairs#requests', as: 'requests'
  post 'chairs/:id/requests' => 'chairs#requests_filtered', as: 'requests_filtered'
  get 'projects/typeahead/:query' => 'projects#typeahead'

  post 'events/hide', to: 'events#hide', as: 'hide_event'
  post 'events/request', to: 'events#show_request', as: 'show_event_request'

  get 'projects/typeahead/:query' => 'projects#typeahead'

  # status 'saved' -> status 'applied'
  #post 'holidays/:id/file', to: 'holidays#file', as: 'file_holiday'
  #post 'holidays/:id/reject', to: 'holidays#reject', as: 'reject_holiday'
  #post 'holidays/:id/accept', to: 'holidays#accept', as: 'accept_holiday'
  post 'trips/:id/hand_in', to: 'trips#hand_in', as: 'hand_in_trip'
  post 'travel_expense_reports/:id/hand_in', to: 'travel_expense_reports#hand_in', as: 'hand_in_travel_expense_report'

  resources :users, only: [:show, :edit, :edit_leave, :update]

end

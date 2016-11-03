Rails.application.routes.draw do
  devise_for :users
  get 'users' => 'users#index'

  get 'extern' => 'users#external_login', as: 'external_login'

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

  # root 'dashboard#index'
  root :to => redirect('/dashboard')
  get 'dashboard', to: 'dashboard#index'
  get 'users/edit_leave', to: 'users#edit_leave'
  get 'users/language', to: 'users#language'

  resources :projects do
    member do
      post 'add_user'
      get 'accept_invitation'
      get 'decline_invitation'
    end
  end

  resources :projects do
    member do
      get 'toggle_status'
      delete 'remove/:user', action: 'remove_user', as: 'remove_user'
      post 'leave'
    end
  end

  #get 'projects/typeahead/:query', to: 'projects#typeahead', constraints: {query: /[^\/]+/}
  get 'projects/hiwi_working_hours/:month_year', to: 'projects#hiwi_working_hours'

  resources :holidays do
    member do
      get 'file'
      get 'accept_reject'
    end
    get 'holidays/file', to: 'holidays#file'
    get 'holidays/accept_reject', to: 'holidays#accept_reject'
  end

  resources :contracts do
    resources :time_sheets, only: [:new, :create, :update, :destroy]
  end
  resources :work_days
  get 'work_days/:year/:month', to: 'work_days#index'
  resources :time_sheets, except: [:new, :create] do
    member do
      get 'withdraw'
      get 'hand_in'
      get 'accept_reject'
      get 'download'
    end

    collection do
      get 'current'
    end
  end


  resources :trips do
    resources :expenses, except: [:show, :index]
    member do
      get 'download'
      get 'file'
      get 'accept_reject'
    end
    get 'trips/file', to: 'trips#file'
    get 'trips/accept_reject', to: 'trips#accept_reject'
  end

  resources :chairs do
    member do
      post 'add_user'
    end
  end

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
  post 'expenses/:id/hand_in', to: 'expenses#hand_in', as: 'hand_in_expense'

  post 'users/:id/upload_signature', to: 'users#upload_signature', as: 'upload_signature'
  post 'users/:id/delete_signature', to: 'users#delete_signature', as: 'delete_signature'

  get '/admin_search', to: 'chairs#admin_search', as: 'admin_search'
  get '/representative_search', to: 'chairs#representative_search', as: 'representative_search'


  resources :users, only: [:show, :edit, :edit_leave, :update]
  get '/users/autocomplete/:query', to: 'users#autocomplete', as: 'autocomplete'
end

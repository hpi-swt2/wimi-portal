Rails.application.routes.draw do
  devise_for :users
  get 'users' => 'users#index'

  get 'extern' => 'users#external_login', as: 'external_login'

  resources :chair_applications
  resources :chairs do
    get 'reporting' => 'reporting#index', as: 'reporting_index'
    get 'reporting/data' => 'reporting#data'
  end
  post 'chairs/:id/users' => 'chairs#add_user', as: :chair_users
  delete 'chairs/:id/users/:request' => 'chairs#remove_user', as: :chair_user
  post 'chairs/:id/admins' => 'chairs#set_admin', as: :chair_admins
  delete 'chairs/:id/admins/:request' => 'chairs#withdraw_admin', as: :chair_admin
  
#  post 'chairs/remove_user', to: 'chairs#remove_from_chair'
#  post 'chairs/destroy', to: 'chairs#destroy'
#  post 'chairs/set_admin', to: 'chairs#set_admin'
#  post 'chairs/withdraw_admin', to: 'chairs#withdraw_admin'

  get 'documents/generate_pdf' => 'documents#generate_pdf', as: 'generate_pdf'

  # root 'dashboard#index'
  root :to => redirect('/dashboard')
  get 'dashboard', to: 'dashboard#index'
  get 'users/edit_leave', to: 'users#edit_leave'
  get 'users/language', to: 'users#language'

  resources :projects do
    member do
      post 'add_user'
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

  resources :contracts do
    resources :time_sheets, only: [:new, :create]
    # parameters in parenthesis are optional
    post ':month/:year(/status/:status)', to: 'time_sheets#create_for_month_year', as: 'create_for_month_year'
  end

  resources :time_sheets, except: [:new, :index] do
    member do
      get 'withdraw'
      patch 'hand_in'
      get 'accept_reject'
      get 'download'
      post 'close'
      get 'reopen'
      get 'send_to_admin'
    end
    collection do
      get 'current'
    end
  end
  
  get 'projects/typeahead/:query' => 'projects#typeahead'

  post 'events/hide', to: 'events#hide', as: 'hide_event'
  post 'events/request', to: 'events#show_request', as: 'show_event_request'

  get 'projects/typeahead/:query' => 'projects#typeahead'

  post 'users/:id/upload_signature', to: 'users#upload_signature', as: 'upload_signature'
  post 'users/:id/delete_signature', to: 'users#delete_signature', as: 'delete_signature'

  resources :users, only: [:show, :edit, :edit_leave, :update]
  get '/users/autocomplete/:query', to: 'users#autocomplete', as: 'autocomplete'
end

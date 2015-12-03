Rails.application.routes.draw do


    # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  resources :publications
  resources :projects
  resources :holidays
  resources :expenses
  resources :travel_expense_reports
  resources :trips do
    member do
      get 'download'
    end
  end
  
  devise_for :users

  # You can have the root of your site routed with "root"
  root 'welcome#index'
end

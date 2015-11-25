Rails.application.routes.draw do
  resources :trips do
    resources :travel_expense_reports
    member do
      get 'download'
    end
  end

    # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  resources :publications
  resources :projects
  resources :holidays
  resources :expenses
  
  devise_for :users

  # You can have the root of your site routed with "root"
  root 'welcome#index'
end

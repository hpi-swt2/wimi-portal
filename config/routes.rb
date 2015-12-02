Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  #scope '(:locale)', locale: /#{I18n.available_locales.join('|')}/ do
    resources :publications
    resources :projects
    resources :holidays
    resources :trips
    resources :expenses
  
    devise_for :users

    resources :users, :only => [:show, :edit, :update]

    # You can have the root of your site routed with "root"
    root 'welcome#index'
  #end



end

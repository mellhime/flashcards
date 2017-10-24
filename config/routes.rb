Rails.application.routes.draw do
  root 'dashboard/cards#random'

  namespace :home do
    resources :users, only: [:new, :create, :index]
    resources :user_sessions, only: :create
  end

  match '/login', to: 'home/user_sessions#new', via: 'get'

  namespace :dashboard do
    resources :packs
    resources :user_sessions, only: :destroy
    resources :users, only: [:edit, :update, :show]
    resources :cards do
      member do
        post "check"
      end
    end
  end

  match '/logout', to: 'dashboard/user_sessions#destroy', via: 'delete'

  post "oauth/callback" => "home/oauths#callback"
  get "oauth/callback" => "home/oauths#callback"
  get "oauth/:provider" => "home/oauths#oauth", :as => :auth_at_provider
  delete "oauth/:provider" => "home/oauths#destroy", :as => :delete_oauth
end

Rails.application.routes.draw do
  root 'cards#random'

  resources :cards do 
    member do
      post "check"
    end
  end

  resources :users
  resources :user_sessions

  match '/login',    to: 'user_sessions#new', via: 'get'
  match '/logout',   to: 'user_sessions#destroy',     via: 'delete'
end

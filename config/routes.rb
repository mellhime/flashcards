Rails.application.routes.draw do
  root 'cards#random'

  resources :cards do 
    member do
      post "check"
    end
  end

  resources :users
  resources :user_sessions

  get 'login' => 'user_sessions#new', :as => :login
  delete 'logout' => 'user_sessions#destroy', :as => :logout
end

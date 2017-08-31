Rails.application.routes.draw do
  resources :cards do 
    member do
      post "check"
    end
  end
  root 'cards#random'
end

Rails.application.routes.draw do
  resources :cards
  root 'static_pages#home'
end

Rails.application.routes.draw do
  resources :cards
  root 'static_pages#home'
  match '/add', to: 'cards#new', via: 'get'
end

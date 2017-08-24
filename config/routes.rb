Rails.application.routes.draw do
  resources :cards
  root 'static_pages#home'
  
  match '/add', to: 'cards#new', via: 'get'
  #match '/edit',      to: 'cards#edit',           via: 'get'
  # match '/cards/new', to: 'cards#create', via: 'get'
  #match '/edit', to: 'cards#edit', via: 'get'
end

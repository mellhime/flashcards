Rails.application.routes.draw do
  resources :cards
  root 'cards#get_random_card'
  match '/check', to: 'cards#check', via: 'patch'
end

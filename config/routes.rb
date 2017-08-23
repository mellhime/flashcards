Rails.application.routes.draw do
	resources :cards, only: :index
	root 'static_pages#home'
end

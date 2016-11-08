Rails.application.routes.draw do
  root 'pictures#index'
  get '/pictures', to: 'pictures#gallery'
  resources :reviews
  resources :pictures
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

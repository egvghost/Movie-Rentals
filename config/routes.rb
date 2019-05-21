Rails.application.routes.draw do
  resources :movies do
    get 'api_search', on: :collection
    get 'api_search_results', on: :collection
    post 'import', on: :collection
    get 'import_error', on: :collection
  end
  resources :genres
  get '/signup', to: 'users#new'
  resources :users
  root 'static_pages#home'
  get '/about', to: 'static_pages#about'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

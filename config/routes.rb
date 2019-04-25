Rails.application.routes.draw do
  resources :movies do
    get 'api_search', on: :collection
    get 'api_search_results', on: :collection
    post 'import', on: :collection
    get 'import_error', on: :collection
  end
  resources :genres
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

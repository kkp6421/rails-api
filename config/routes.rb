Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'static_pages#index'
  get '/about', to: 'static_pages#index'
  get '/contact', to: 'static_pages#index'
  scope :api do
    get '/users/profile', to: 'users#show'
    post '/login', to: 'sessions#create'
    post '/users/new', to: 'users#create'
    get '/tasks', to: 'tasks#index'
    post 'tasks/new', to: 'tasks#create'
    patch '/tasks/done/:id', to: 'tasks#done'
    put '/tasks/done/:id', to: 'tasks#done'
  end
  get '*not_found' => 'application#rescue404'
  post '*not_found' => 'application#rescue404'
end

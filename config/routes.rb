Rails.application.routes.draw do
  root 'tasks#index' 
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
resources :tasks, only: [:index, :new, :create, :show, :edit, :update, :destroy]


get 'login', to: 'sessions#new'
post 'login', to: 'sessions#create'
delete 'logout', to: 'sessions#destroy'

resources :users
end

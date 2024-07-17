Rails.application.routes.draw do
  root 'tasks#index' 

  resources :tasks do
    collection do
      get 'sort'
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
resources :tasks, only: [:index, :new, :create, :show, :edit, :update, :destroy]
end

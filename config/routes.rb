Rails.application.routes.draw do
  # ログイン関連のルーティング
  get 'login', to: 'sessions#new', as: 'new_session'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  # アカウント関連のルーティング
  get 'signup', to: 'users#new', as: 'new_user'
  resources :users, only: [:create, :update, :destroy, :show, :edit]

  # 管理者用のルーティング
  namespace :admin do
    resources :users
  end

  # タスクのルーティング
  resources :tasks, only: [:index, :new, :create, :show, :edit, :update, :destroy]

  # ルートの定義
  root 'tasks#index'
end

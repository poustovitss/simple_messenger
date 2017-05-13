Rails.application.routes.draw do

  devise_for :users

  root 'conversations#index'

  resources :users, except: %i[create, show] do
    member do
      get 'role', to: 'users#role'
      post 'role', to: 'users#role_update'
      post 'toggle_user_state', to: 'users#toggle_user_state'
    end
  end

  post 'create_user', to: 'users#create', as: :create_user

  resources :conversations, only: %i[index create show destroy] do
    resources :messages, only: :create do
    end
  end

  get 'unread', to: 'messages#unread'

  mount ActionCable.server, at: '/cable'
end

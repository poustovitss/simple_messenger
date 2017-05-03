Rails.application.routes.draw do

  devise_for :users

  root 'dashboard#index'

  resources :users, except: :create do
    member do
      get 'role',              to: 'users#role'
      post 'users/:id/role',   to: 'users#role_update'
      post 'toggle_user_state', to: 'users#toggle_user_state'
    end
  end

  post 'create_user', to: 'users#create', as: :create_user

  resources :conversations, only: %i[index create show destroy] do
    resources :messages
  end
end

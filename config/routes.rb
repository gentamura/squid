Rails.application.routes.draw do
  root 'static_pages#home'
  get 'signup' => 'users#new'
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'
  get 'mypage' => 'users#mypage'
  scope :mypage do
    resources :money_transfers, only: [:index, :new, :create]
    resources :friendships, only: [:index, :create]
    get 'friendships/new/:id', to: 'friendships#new', as: :new_friendship
  end
  resources :users

  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'
end

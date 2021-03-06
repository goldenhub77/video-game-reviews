Rails.application.routes.draw do
  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  devise_for :users

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :video_games
  resources :reviews, only: [:index, :show, :destroy, :update] do
    member do
        post :vote
    end
  end

  resources :users do
    resources :video_games
    resources :reviews
  end

  resources :video_games do
    resources :reviews
  end

  resources :admins

  namespace :admins do
    resources :reviews, only: [:destroy]
    resources :video_games, only: [:destroy]
    resources :users do
      resources :video_games
      resources :reviews
    end
  end

  namespace :api do
    namespace :v1 do
      resources :search, only: [:index]
    end
  end



  root 'video_games#home'

  match '*a', :to => 'errors#routing', via: :get
end

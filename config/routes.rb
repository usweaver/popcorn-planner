Rails.application.routes.draw do
  devise_for :users
  get "users/search" => "groups#search_users", as: "search_users"
  root to: "pages#home"
  resources :groups, only: [:index, :show, :new, :create]
  resources :events, only: [:index, :show, :new, :create, :delete]
  resources :movies, only: [:index, :show] do
    collection do
      get "search"
    end
    member do
      patch "vote"
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end

Rails.application.routes.draw do
  get "households/index"
  get "households/show"
  get "households/new"
  get "households/create"
  get "households/edit"
  get "households/update"
  get "shopping_items/create"
  get "shopping_items/update"
  get "shopping_items/destroy"
  get "shopping_lists/index"
  get "shopping_lists/show"
  get "shopping_lists/new"
  get "shopping_lists/create"
  get "shopping_lists/edit"
  get "shopping_lists/update"
  get "shopping_lists/destroy"
  # Authentication routes
  get "signup", to: "users#new"
  post "signup", to: "users#create"
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  # Shopping lists routes
  root "shopping_lists#index"

  resources :shopping_lists do
    member do
      post :clone
      post :merge
    end
    resources :shopping_items, only: [ :create, :update, :destroy ] do
      member do
        patch :toggle_completed
        patch :defer
        patch :update_position
      end
    end
  end

  resources :households, only: [ :index, :show, :new, :create, :edit, :update ] do
    member do
      post :add_member
      delete :remove_member
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end

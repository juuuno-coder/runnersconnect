Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Web Authentication
  devise_for :users

  # API Authentication routes (Manual mapping to preserve existing API endpoints)
  namespace :api do
    namespace :v1 do
      devise_scope :user do
        post 'auth/login', to: 'sessions#create'
        delete 'auth/logout', to: 'sessions#destroy'
        post 'auth/signup', to: 'registrations#create'
      end
    end
  end


  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  namespace :api do
    namespace :v1 do
      resources :status, only: [:index]
      resources :races, only: [:index, :show]
      resources :registrations, only: [:create, :index], controller: 'race_registrations'
      resource :profile, only: [:show, :update]

      namespace :admin do
        get 'dashboard', to: 'dashboard#index'
        resources :records, only: [] do
          collection do
            post :upload
          end
        end
      end


    end
  end

  resources :registrations, only: [:index, :show, :new, :create]
  resources :crews, only: [:index, :new, :create, :show]
  resources :races, only: [:index, :show] do
    resources :products, only: [:index]
  end
  resources :products, only: [:show]
  resource :cart, only: [:show] do
    post :add_item
    patch :update_quantity
    delete :remove_item
    delete :clear
  end
  resources :orders, only: [:index, :show, :new, :create]
  resources :rankings, only: [:index]
  resources :records, only: [:index, :show]
  resource :profile, only: [:show, :edit, :update]
  resource :onboarding, only: [:show, :update] do
    post :skip, on: :collection
  end

  namespace :admin do
    root to: "dashboard#index"
    resources :dashboard, only: [:index]
    resources :races
    resources :poster_analyses, only: [:create]
    resources :settlements, only: [:index] do
      member do
        post :approve
        post :reject
        post :mark_paid
      end
    end
  end

  namespace :organizer do
    root to: "dashboard#index"
    resources :dashboard, only: [:index]
    resources :settlements, only: [:index, :show] do
      member do
        post :request_payout
      end
    end
    resources :races, only: [:index, :show] do
      member do
        get :payments          # 결제 현황
      end

      resources :bib_numbers, only: [:index, :update] do
        post :bulk_reassign, on: :collection
      end

      resources :participants, only: [:index, :show]

      resources :souvenirs, only: [:index] do
        member do
          post :mark_received
        end
      end

      resources :records, only: [:index] do
        collection do
          get :upload_form
          post :bulk_upload
          get :upload_result
          get :download_sample
        end
      end

      resources :record_statistics, only: [:index]

      resources :products do
        member do
          delete :delete_image
        end
      end
    end
  end

  root "home#index"
end

Rails.application.routes.draw do
  # Authentication routes
  post "sign_in", to: "sessions#create"
  post "sign_up", to: "registrations#create"
  resources :sessions, only: [:index, :show, :destroy]
  resource :password, only: [:edit, :update]

  # Identity namespace
  namespace :identity do
    resource :email, only: [:edit, :update]
    resource :email_verification, only: [:show, :create]
    resource :password_reset, only: [:new, :edit, :create, :update]
  end

  # API v1 namespace
  namespace :api do
    namespace :v1 do
      # Gravity Forms routes
      post 'gravity_forms/fetch_and_save/:company_name', to: 'gravity_forms#fetch_and_save'
      get 'gravity_forms/entries', to: 'gravity_forms#entries'
      get 'gravity_forms_data', to: 'gravity_forms#index'

      # Call Rail Data routes
      get 'call_rail_data/fetch_and_store', to: 'call_rail_data#fetch_and_store'
      get 'call_rail_data', to: 'call_rail_data#index'
    end
  end
end

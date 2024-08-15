Rails.application.routes.draw do
  post "sign_in", to: "sessions#create"
  post "sign_up", to: "registrations#create"
  resources :sessions, only: [:index, :show, :destroy]
  resource  :password, only: [:edit, :update]
  namespace :identity do
    resource :email,              only: [:edit, :update]
    resource :email_verification, only: [:show, :create]
    resource :password_reset,     only: [:new, :edit, :create, :update]
  end
  namespace :api do
    namespace :v1 do
      post 'gravity_forms/fetch_and_save/:company_name', to: 'gravity_forms#fetch_and_save'
      get 'gravity_forms/entries', to: 'gravity_forms#entries'
      get 'call_rail_data/fetch_and_store', to: 'call_rail_data#fetch_and_store'
      get 'call_rail_data', to: 'call_rail_data#index'
      get 'gravity_forms_data', to: 'gravity_forms#index'
      post 'gravity_forms/fetch_and_save/:company_name', to: 'gravity_forms#fetch_and_save'
      get 'gravity_forms/entries', to: 'gravity_forms#entries'
    end
  end
end

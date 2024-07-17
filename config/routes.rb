Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'call_rail_data/fetch_and_store', to: 'call_rail_data#fetch_and_store'
      get 'call_rail_data', to: 'call_rail_data#index'
    end
  end
end

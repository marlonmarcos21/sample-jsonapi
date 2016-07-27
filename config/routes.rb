Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'sessions' }

  # Main API
  namespace :api do
    jsonapi_resources :products,       only:   [:index, :show]
    jsonapi_resources :images,         only:   [:index, :show]
    jsonapi_resources :categories,     only:   [:index, :show]
    jsonapi_resources :sub_categories, only:   [:index, :show]

    jsonapi_resource  :user,           except: [:destroy]

    devise_for :users, controllers: { sessions: 'api/sessions' }
  end

  root to: 'application#four_zero_four'
end

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  get '/health', to: 'health#index'

  namespace :api do
    namespace :v1 do
      post '/auth/register', to: 'auth#register'
      post '/auth/login',    to: 'auth#login'
      get  '/auth/me',       to: 'auth#me'
      resources :products, only: [:index, :show, :create, :update, :destroy]
    end
  end
end

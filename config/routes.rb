require 'sidekiq/web'

Rails.application.routes.draw do
  # 🔒 Protect Sidekiq Dashboard
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    ActiveSupport::SecurityUtils.secure_compare(username, ENV['SIDEKIQ_USER'] || 'admin') &
    ActiveSupport::SecurityUtils.secure_compare(password, ENV['SIDEKIQ_PASSWORD'] || 'password')
  end

  mount Sidekiq::Web => "/sidekiq"

  # Swagger
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  # Health check
  get '/health', to: 'health#index'

  namespace :api do
    namespace :v1 do
      post '/auth/register', to: 'auth#register'
      post '/auth/login',    to: 'auth#login'
      get  '/auth/me',       to: 'auth#me'
      post '/auth/refresh',  to: 'auth#refresh'
      post '/auth/logout',   to: 'auth#logout'

      resources :products, only: [:index, :show, :create, :update, :destroy]

      resources :inventories, only: [:index, :show, :create, :destroy] do
        member do
          patch :adjust
        end
      end
    end
  end
end
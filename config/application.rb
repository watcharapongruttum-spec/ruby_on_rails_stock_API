require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)

require_relative '../app/middleware/request_logger'

module StockApi
  class Application < Rails::Application
    config.load_defaults 7.0
    config.api_only = true

    config.middleware.use RequestLogger
    config.middleware.use Rack::Attack

    config.active_job.queue_adapter = :sidekiq

  end
end

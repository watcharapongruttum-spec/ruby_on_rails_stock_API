class SentryTestJob < ApplicationJob
  queue_as :default

  def perform
    raise "💥 Sidekiq Sentry Test Error"
  end
end
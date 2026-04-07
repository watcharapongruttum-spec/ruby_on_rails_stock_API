Sidekiq.configure_server do |config|
  config.redis = {
    url: ENV.fetch("REDIS_URL", "redis://redis:6379/0"),
    timeout: 10,        # เพิ่มจาก default 5 → 10
    connect_timeout: 5
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    url: ENV.fetch("REDIS_URL", "redis://redis:6379/0"),
    timeout: 10,
    connect_timeout: 5
  }
end
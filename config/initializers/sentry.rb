Sentry.init do |config|
  config.dsn = ENV['SENTRY_DSN']

  # Environment
  config.environment = ENV.fetch("RAILS_ENV", "development")
  config.enabled_environments = %w[production staging]

  # Performance monitoring
  config.traces_sample_rate  = Rails.env.production? ? 0.2 : 1.0
  config.profiles_sample_rate = Rails.env.production? ? 0.2 : 1.0  # 👈 CPU profiling

  # Breadcrumbs
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]

  # ส่งข้อมูล user / request
  config.send_default_pii = true

  # 👈 กรอง sensitive data ไม่ให้ขึ้น Sentry
  config.before_send = lambda do |event, hint|
    # กรอง password / token ออก
    if event.request
      event.request.data&.delete("password")
      event.request.data&.delete("token")
      event.request.data&.delete("secret")
    end
    event
  end

  # 👈 ไม่ส่ง error พวกนี้ขึ้น Sentry (noise ไม่มีประโยชน์)
  config.excluded_exceptions += [
    "ActionController::RoutingError",   # คนพิมพ์ URL ผิด
    "ActionController::BadRequest",
    "Rack::QueryParser::InvalidParameterError"
  ]

  # 👈 app trace จะ highlight ใน stack trace ให้เห็นชัด
  config.rails.tracing_subscribers = Sentry::Rails::Tracing.default_subscribers

  # 👈 ถ้า job retry เกิน limit จึงส่ง Sentry (ไม่ส่งทุก retry)
  config.sidekiq.report_after_job_retries = true
end
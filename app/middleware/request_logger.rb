class RequestLogger
  def initialize(app)
    @app = app
    @logger = Rails.logger
  end

  def call(env)
    request   = Rack::Request.new(env)
    started   = Time.now
    status, headers, body = @app.call(env)
    duration  = ((Time.now - started) * 1000).round(2)

    @logger.info(
      "[API] #{request.request_method} #{request.path} → #{status} (#{duration}ms)"
    )

    [status, headers, body]
  end
end
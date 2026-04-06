Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

Rack::Attack.throttle('api/ip', limit: 60, period: 1.minute) do |req|
  req.ip if req.path.start_with?('/api/')
end

Rack::Attack.throttle('login/ip', limit: 5, period: 1.minute) do |req|
  req.ip if req.path == '/api/v1/auth/login' && req.post?
end

Rack::Attack.throttle('login/email', limit: 10, period: 1.hour) do |req|
  if req.path == '/api/v1/auth/login' && req.post?
    body = JSON.parse(req.body.read) rescue {}
    req.body.rewind
    body['email']&.downcase&.strip
  end
end

Rack::Attack.throttle('register/ip', limit: 3, period: 1.hour) do |req|
  req.ip if req.path == '/api/v1/auth/register' && req.post?
end

Rack::Attack.throttled_responder = lambda do |env|
  match_data  = env['rack.attack.match_data'] || {}
  period      = match_data[:period] || 60
  epoch_time  = match_data[:epoch_time] || Time.now.to_i
  retry_after = period - (epoch_time % period)

  [
    429,
    { 'Content-Type' => 'application/json', 'Retry-After' => retry_after.to_s },
    [{ error: 'Too Many Requests', retry_after: retry_after }.to_json]
  ]
end

Rack::Attack.enabled = false if Rails.env.test?

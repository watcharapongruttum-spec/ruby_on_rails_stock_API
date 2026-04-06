# app/services/jwt_service.rb
class JwtService

  SECRET_KEY = ENV.fetch('JWT_SECRET_KEY', 'fallback_dev_secret_change_in_production')
  EXPIRY     = 24.hours.to_i

  def self.encode(payload)
    payload[:exp] = Time.now.to_i + EXPIRY
    JWT.encode(payload, SECRET_KEY, 'HS256')
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY, true, algorithm: 'HS256')
    HashWithIndifferentAccess.new(decoded.first)
  rescue JWT::ExpiredSignature
    raise AuthenticationError, 'Token หมดอายุแล้ว'
  rescue JWT::DecodeError
    raise AuthenticationError, 'Token ไม่ถูกต้อง'
  end
end
# ← ลบ class AuthenticationError ออกจากที่นี่
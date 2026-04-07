# app/services/jwt_service.rb
class JwtService
  SECRET_KEY = ENV.fetch('JWT_SECRET')
  
  ACCESS_TOKEN_EXPIRY  = 15.minutes.to_i    # สั้น
  REFRESH_TOKEN_EXPIRY = 7.days.to_i        # ยาว
  
  ISSUER = 'stock_api'
  AUDIENCE = 'stock_client'

  # ──────────────────────────────────────────
  # Encode
  # ──────────────────────────────────────────
  def self.encode_access(payload)
    payload[:exp] = Time.now.to_i + ACCESS_TOKEN_EXPIRY
    payload[:iss] = ISSUER
    payload[:aud] = AUDIENCE
    payload[:type] = 'access'
    JWT.encode(payload, SECRET_KEY, 'HS256')
  end

  def self.encode_refresh(user_id)
    payload = {
      user_id: user_id,
      exp: Time.now.to_i + REFRESH_TOKEN_EXPIRY,
      iss: ISSUER,
      aud: AUDIENCE,
      type: 'refresh',
      jti: SecureRandom.uuid    # Unique ID สำหรับยกเลิกได้
    }
    JWT.encode(payload, SECRET_KEY, 'HS256')
  end

  # ──────────────────────────────────────────
  # Decode
  # ──────────────────────────────────────────
  def self.decode_access(token)
    decode_with_verification(token, 'access')
  end

  def self.decode_refresh(token)
    payload = decode_with_verification(token, 'refresh')
    
    # ตรวจว่าถูกยกเลิกไหม (เฉพาะ refresh token)
    if RevokedToken.revoked?(payload[:jti])
      raise AuthenticationError, 'Token ถูกยกเลิกแล้ว'
    end
    
    payload
  end

  # ──────────────────────────────────────────
  # Revoke
  # ──────────────────────────────────────────
  def self.revoke_refresh_token(jti, user_id)
    RevokedToken.revoke!(jti, user_id, Time.now + REFRESH_TOKEN_EXPIRY)
  end

  # ──────────────────────────────────────────
  # Private Helpers
  # ──────────────────────────────────────────
  private

  def self.decode_with_verification(token, expected_type)
    decoded = JWT.decode(token, SECRET_KEY, true, {
      algorithm: 'HS256',
      iss: ISSUER,
      aud: AUDIENCE,
      verify_iss: true,
      verify_aud: true
    })
    
    payload = HashWithIndifferentAccess.new(decoded.first)
    
    # ตรวจประเภท token
    if payload[:type] != expected_type
      raise AuthenticationError, "Token type ไม่ถูกต้อง (คาดหวัง: #{expected_type})"
    end
    
    payload
  rescue JWT::ExpiredSignature
    raise AuthenticationError, 'Token หมดอายุแล้ว'
  rescue JWT::DecodeError, JWT::InvalidIssuerError, JWT::InvalidAudError
    raise AuthenticationError, 'Token ไม่ถูกต้อง'
  end
end
# app/services/auth_service.rb
class AuthService
  def register(attributes)
    user = User.new(attributes)
    raise ActiveRecord::RecordInvalid.new(user) unless user.save
    
    WelcomeEmailJob.perform_later(user.id)
    
    generate_tokens(user)
  end

  def login(email:, password:)
    user = User.find_by('LOWER(email) = LOWER(?)', email)
    raise AuthenticationError, 'อีเมลหรือรหัสผ่านไม่ถูกต้อง' unless user&.authenticate(password)
    
    generate_tokens(user)
  end

  def current_user_from_token(token)
    raise AuthenticationError, 'ไม่พบ Token' if token.blank?
    
    payload = JwtService.decode_access(token)
    user = User.find_by(id: payload[:user_id])
    raise AuthenticationError, 'ไม่พบผู้ใช้งาน' unless user
    
    user
  end

  # ──────────────────────────────────────────
  # Refresh Token Logic (ใหม่)
  # ──────────────────────────────────────────
  def refresh_tokens(refresh_token)
    payload = JwtService.decode_refresh(refresh_token)
    
    user = User.find_by(id: payload[:user_id])
    raise AuthenticationError, 'ไม่พบผู้ใช้งาน' unless user
    
    # สร้างชุดใหม่
    generate_tokens(user)
  end

  def logout(refresh_token)
    payload = JwtService.decode_refresh(refresh_token)
    JwtService.revoke_refresh_token(payload[:jti], payload[:user_id])
    true
  rescue AuthenticationError
    # ถ้า token ไม่ถูกต้องหรือหมดอายุ ถือว่า logout สำเร็จอยู่แล้ว
    true
  end

  private

  def generate_tokens(user)
    {
      user: user,
      access_token: JwtService.encode_access({ user_id: user.id, role: user.role }),
      refresh_token: JwtService.encode_refresh(user.id)
    }
  end
end
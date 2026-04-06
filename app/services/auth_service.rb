# app/services/auth_service.rb
class AuthService

  def register(attributes)
    user = User.new(attributes)
    raise ActiveRecord::RecordInvalid.new(user) unless user.save

    WelcomeEmailJob.perform_later(user.id)  

    token = JwtService.encode({ user_id: user.id, role: user.role })
    { user: user, token: token }
  end

  def login(email:, password:)
    user = User.find_by('LOWER(email) = LOWER(?)', email)
    raise AuthenticationError, 'อีเมลหรือรหัสผ่านไม่ถูกต้อง' unless user&.authenticate(password)
    token = JwtService.encode({ user_id: user.id, role: user.role })
    { user: user, token: token }
  end

  def current_user_from_token(token)
    raise AuthenticationError, 'ไม่พบ Token' if token.blank?

    payload = JwtService.decode(token)
    user    = User.find_by(id: payload[:user_id])
    raise AuthenticationError, 'ไม่พบผู้ใช้งาน' unless user

    user
  end
end
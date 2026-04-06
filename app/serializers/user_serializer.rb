# app/serializers/user_serializer.rb
class UserSerializer

  def initialize(user)
    @user = user
  end

  def as_json(*)
    {
      id:         @user.id,
      email:      @user.email,
      name:       @user.name,
      role:       @user.role,
      created_at: @user.created_at&.iso8601
      # ❌ ห้ามส่ง password_digest ออกไปเด็ดขาด
    }
  end
end
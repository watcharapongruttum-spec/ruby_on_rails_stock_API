class RegisterForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :email,                 :string
  attribute :password,              :string
  attribute :password_confirmation, :string
  attribute :name,                  :string
  attribute :role,                  :string, default: 'staff'

  validates :email,    presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }
  validates :name,     presence: true, length: { maximum: 100 }
  validates :role,     inclusion: { in: UserRole::ALL }
  validate  :passwords_match

  def to_h
    {
      email:                 email,
      password:              password,
      password_confirmation: password_confirmation,
      name:                  name,
      role:                  role
    }
  end

  private

  def passwords_match
    return if password.blank?
    errors.add(:password_confirmation, 'ไม่ตรงกัน') if password != password_confirmation
  end
end

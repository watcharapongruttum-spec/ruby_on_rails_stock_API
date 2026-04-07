# app/models/user.rb
class User < ApplicationRecord

  has_secure_password

  # ──────────────────────────────────────────
  # Associations
  # ──────────────────────────────────────────
  has_many :sales
  has_many :sale_items, through: :sales
  has_many :products,   through: :sale_items


  # ──────────────────────────────────────────
  # Domain Rules (กฎที่ต้องเคารพเสมอ)
  # ──────────────────────────────────────────
  ROLES = UserRole::ALL

  validates :email,    presence: true,
                       format: { with: URI::MailTo::EMAIL_REGEXP },
                       uniqueness: { case_sensitive: false }
  validates :name,     presence: true, length: { maximum: 100 }
  validates :password, length: { minimum: 6 }, allow_nil: true
  validates :role,     inclusion: { in: UserRole::ALL }

  def admin?
    role == UserRole::ADMIN
  end

  def staff?
    role == UserRole::STAFF
  end
end
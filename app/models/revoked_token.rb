# app/models/revoked_token.rb
class RevokedToken < ApplicationRecord
  belongs_to :user
  
  validates :jti, presence: true, uniqueness: true
  validates :expires_at, presence: true
  
  # Scope: ลบข้อมูลเก่าที่หมดอายุแล้ว (เรียกจาก rake task หรือ cron)
  scope :expired, -> { where('expires_at < ?', Time.now) }
  
  # Method: ตรวจว่า token นี้ถูกยกเลิกไหม
  def self.revoked?(jti)
    exists?(jti: jti)
  end
  
  # Method: ยกเลิก token
  def self.revoke!(jti, user_id, expiry)
    create!(jti: jti, user_id: user_id, expires_at: expiry)
  end
  
  # Method: ทำความสะอาดข้อมูลเก่า (เรียกเป็นระยะ)
  def self.cleanup!
    expired.delete_all
  end
end
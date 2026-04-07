namespace :tokens do
  desc "ลบ revoked tokens ที่หมดอายุแล้วออกจากฐานข้อมูล"
  task cleanup: :environment do
    puts "[#{Time.current}] 🧹 เริ่มทำความสะอาด revoked tokens..."
    
    # ใช้ delete_all เพื่อความเร็ว (ไม่เรียก callback)
    count = RevokedToken.where('expires_at < ?', Time.current).delete_all
    
    puts "[#{Time.current}] ✅ ลบสำเร็จ: #{count} รายการ"
  end
end

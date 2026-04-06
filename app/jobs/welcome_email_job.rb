class WelcomeEmailJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find_by(id: user_id)
    return unless user

    # ตัวอย่าง — ในระบบจริงจะเรียก EmailClient
    Rails.logger.info "[Job] ส่ง welcome email ถึง #{user.email}"
    # EmailClient.new.send_welcome(user)
  end
end
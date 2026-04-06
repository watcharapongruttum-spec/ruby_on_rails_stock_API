class WelcomeEmailJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find_by(id: user_id)
    return unless user

    Rails.logger.info("[WelcomeEmailJob] Sending welcome email to #{user.email}")
    # ActionMailer จะมาเพิ่มตรงนี้ตอนมี mailer จริง
  end
end

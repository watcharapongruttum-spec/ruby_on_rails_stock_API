# app/jobs/cleanup_tokens_job.rb
class CleanupTokensJob < ApplicationJob
  queue_as :default

  def perform
    Sentry.set_tags(
      job:   "CleanupTokensJob",
      queue: "default"
    )

    Rails.logger.info "[CleanupTokensJob] Start..."

    count = RevokedToken.where('expires_at < ?', Time.current).delete_all

    Rails.logger.info "[CleanupTokensJob] Deleted: #{count}"

    Sentry.set_context("cleanup_result", {
      deleted_count: count,
      ran_at:        Time.current
    })
  end
end
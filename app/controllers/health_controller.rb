class HealthController < ApplicationController
  skip_before_action :authenticate_user!, raise: false

  def index
    db_ok = database_ok?
    status = db_ok ? :ok : :service_unavailable

    render json: {
      status:    db_ok ? 'ok' : 'error',
      timestamp: Time.now.utc.iso8601,
      checks:    { database: db_ok }
    }, status: status
  end

  private

  def database_ok?
    ActiveRecord::Base.connection.execute('SELECT 1')
    true
  rescue StandardError
    false
  end
end

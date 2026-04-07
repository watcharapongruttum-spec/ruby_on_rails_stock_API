# app/controllers/application_controller.rb
class ApplicationController < ActionController::API

  before_action :authenticate_user!
  before_action :set_sentry_context  # 👈 เพิ่มบรรทัดนี้

  # ──────────────────────────────────────────
  # Auth Helpers
  # ──────────────────────────────────────────
  def authenticate_user!
    @current_user = AuthService.new.current_user_from_token(bearer_token)
  rescue AuthenticationError => e
    Rails.logger.warn "[AUTH_FAIL] IP: #{request.remote_ip}, Error: #{e.message}"
    render json: { error: e.message }, status: :unauthorized
  end

  def current_user
    @current_user
  end

  def require_admin!
    render json: { error: 'สิทธิ์ไม่เพียงพอ' }, status: :forbidden unless current_user&.admin?
  end

  # ──────────────────────────────────────────
  # Error Handlers
  # ──────────────────────────────────────────
  rescue_from ActiveRecord::RecordNotFound,       with: :not_found
  rescue_from ActiveRecord::RecordInvalid,        with: :unprocessable_entity
  rescue_from ActionController::ParameterMissing, with: :bad_request
  rescue_from AuthenticationError,                with: :unauthorized
  rescue_from InventoryError,                     with: :inventory_error

  private

  # ──────────────────────────────────────────
  # Sentry Context                             # 👈 เพิ่ม section นี้
  # ──────────────────────────────────────────
  def set_sentry_context
    return unless current_user

    Sentry.set_user(
      id:    current_user.id,
      email: current_user.email
    )

    Sentry.set_tags(
      role:        current_user.admin? ? "admin" : "user",
      endpoint:    "#{request.method} #{request.path}",
      remote_ip:   request.remote_ip
    )
  end

  # ──────────────────────────────────────────
  # Error Handlers (private)
  # ──────────────────────────────────────────
  def inventory_error(error)
    render json: { error: error.message }, status: :unprocessable_entity
  end

  def bearer_token
    header = request.headers['Authorization']
    header&.split(' ')&.last
  end

  def not_found(error)
    render json: { error: error.message }, status: :not_found
  end

  def unprocessable_entity(error)
    render json: { error: error.record.errors.full_messages }, status: :unprocessable_entity
  end

  def bad_request(error)
    render json: { error: error.message }, status: :bad_request
  end

  def unauthorized(error)
    render json: { error: error.message }, status: :unauthorized
  end
end
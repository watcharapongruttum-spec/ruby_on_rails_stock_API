# app/controllers/application_controller.rb
class ApplicationController < ActionController::API

  # ──────────────────────────────────────────
  # Auth Helpers (ใช้ใน Controller ทุกตัว)
  # ──────────────────────────────────────────
  def authenticate_user!
    @current_user = AuthService.new.current_user_from_token(bearer_token)
  rescue AuthenticationError => e
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

  private

  def bearer_token
    header = request.headers['Authorization']
    header&.split(' ')&.last  # "Bearer <token>" → "<token>"
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
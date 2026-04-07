# app/controllers/api/v1/auth_controller.rb
module Api
  module V1
    class AuthController < ApplicationController
      # ไม่ต้องล็อกอินสำหรับ: register, login, refresh, logout
      skip_before_action :authenticate_user!, only: [:register, :login, :refresh, :logout]
      before_action :authenticate_user!, only: [:me]

      def register
        result = AuthService.new.register(register_params)
        render json: {
          access_token: result[:access_token],
          refresh_token: result[:refresh_token],
          user: UserSerializer.new(result[:user]).as_json
        }, status: :created
      end

      def login
        result = AuthService.new.login(
          email: params[:email],
          password: params[:password]
        )
        render json: {
          access_token: result[:access_token],
          refresh_token: result[:refresh_token],
          user: UserSerializer.new(result[:user]).as_json
        }, status: :ok
      end

      def refresh
        result = AuthService.new.refresh_tokens(params[:refresh_token])
        render json: {
          access_token: result[:access_token],
          refresh_token: result[:refresh_token]   # ให้ refresh token ใหม่ด้วย (rotation)
        }, status: :ok
      end

      def logout
        AuthService.new.logout(params[:refresh_token])
        render json: { message: 'ออกจากระบบสำเร็จ' }, status: :ok
      end

      def me
        render json: { user: UserSerializer.new(current_user).as_json }, status: :ok
      end

      private

      def register_params
        params.permit(:email, :password, :password_confirmation, :name, :role)
      end
    end
  end
end
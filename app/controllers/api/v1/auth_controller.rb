module Api
  module V1
    class AuthController < ApplicationController
      before_action :authenticate_user!, only: [:me]

      def register
        form = RegisterForm.new(register_params)
        return render json: { errors: form.errors.full_messages }, status: :unprocessable_entity unless form.valid?

        result = AuthService.new.register(form.to_h)
        render json: { token: result[:token], user: UserSerializer.new(result[:user]).as_json }, status: :created
      end

      def login
        form = LoginForm.new(login_params)
        return render json: { errors: form.errors.full_messages }, status: :unprocessable_entity unless form.valid?

        result = AuthService.new.login(email: form.email, password: form.password)
        render json: { token: result[:token], user: UserSerializer.new(result[:user]).as_json }
      end

      def me
        render json: { user: UserSerializer.new(current_user).as_json }
      end

      private

      def register_params = params.permit(:email, :password, :password_confirmation, :name, :role)
      def login_params    = params.permit(:email, :password)
    end
  end
end

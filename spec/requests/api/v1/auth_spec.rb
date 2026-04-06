require 'swagger_helper'

RSpec.describe 'Auth API', type: :request do

  path '/api/v1/auth/register' do
    post 'สมัครสมาชิก' do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: {
          email:                 { type: :string, example: 'user@example.com' },
          password:              { type: :string, example: '123456' },
          password_confirmation: { type: :string, example: '123456' },
          name:                  { type: :string, example: 'John Doe' },
          role:                  { type: :string, enum: ['admin', 'staff'] }
        },
        required: ['email', 'password', 'password_confirmation', 'name']
      }

      response '201', 'สมัครสำเร็จ' do
        let(:body) { { email: 'new@test.com', password: '123456', password_confirmation: '123456', name: 'Test' } }
        schema type: :object, properties: { token: { type: :string }, user: { '$ref' => '#/components/schemas/User' } }
        run_test!
      end

      response '422', 'ข้อมูลไม่ถูกต้อง' do
        let(:body) { { email: 'bad-email', password: '123' } }
        schema '$ref' => '#/components/schemas/Errors'
        run_test!
      end
    end
  end

  path '/api/v1/auth/login' do
    post 'เข้าสู่ระบบ' do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: {
          email:    { type: :string, example: 'admin@test.com' },
          password: { type: :string, example: '123456' }
        },
        required: ['email', 'password']
      }

      response '200', 'เข้าสู่ระบบสำเร็จ' do
        before { create(:user, email: 'admin@test.com', password: '123456', password_confirmation: '123456', name: 'Admin') }
        let(:body) { { email: 'admin@test.com', password: '123456' } }
        schema type: :object, properties: { token: { type: :string }, user: { '$ref' => '#/components/schemas/User' } }
        run_test!
      end

      response '401', 'อีเมลหรือรหัสผ่านไม่ถูกต้อง' do
        let(:body) { { email: 'nobody@test.com', password: 'wrong' } }
        schema '$ref' => '#/components/schemas/Error'
        run_test!
      end
    end
  end

  path '/api/v1/auth/me' do
    get 'ดูข้อมูลตัวเอง' do
      tags 'Authentication'
      security [{ bearerAuth: [] }]
      produces 'application/json'
      parameter name: :Authorization, in: :header, type: :string

      response '200', 'สำเร็จ' do
        let(:user) { create(:user) }
        let(:Authorization) { "Bearer #{JwtService.encode({ user_id: user.id, role: user.role })}" }
        schema type: :object, properties: { user: { '$ref' => '#/components/schemas/User' } }
        run_test!
      end

      response '401', 'ไม่ได้ login' do
        let(:Authorization) { 'Bearer invalid' }
        schema '$ref' => '#/components/schemas/Error'
        run_test!
      end
    end
  end
end

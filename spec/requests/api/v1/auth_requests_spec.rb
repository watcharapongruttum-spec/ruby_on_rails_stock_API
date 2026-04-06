require 'rails_helper'

RSpec.describe 'Auth API', type: :request do
  describe 'POST /api/v1/auth/register' do
    let(:valid_params) do
      {
        email: 'new@test.com',
        password: '123456',
        password_confirmation: '123456',
        name: 'New User',
        role: 'staff'
      }
    end

    it 'สมัครสำเร็จ ได้รับ token กลับมา' do
      post '/api/v1/auth/register', params: valid_params, as: :json
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)).to have_key('token')
    end

    it 'fail เมื่อ email ซ้ำ' do
      create(:user, email: 'new@test.com')
      post '/api/v1/auth/register', params: valid_params, as: :json
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'fail เมื่อ password ไม่ตรงกัน' do
      post '/api/v1/auth/register',
        params: valid_params.merge(password_confirmation: 'wrong'),
        as: :json
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'POST /api/v1/auth/login' do
    let!(:user) { create(:user, email: 'test@test.com', password: '123456', password_confirmation: '123456') }

    it 'login สำเร็จ' do
      post '/api/v1/auth/login',
        params: { email: 'test@test.com', password: '123456' },
        as: :json
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to have_key('token')
    end

    it 'fail เมื่อ password ผิด' do
      post '/api/v1/auth/login',
        params: { email: 'test@test.com', password: 'wrong' },
        as: :json
      expect(response).to have_http_status(:unauthorized)
    end
  end
end

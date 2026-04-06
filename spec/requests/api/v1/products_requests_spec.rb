require 'rails_helper'

RSpec.describe 'Products API', type: :request do
  let!(:admin) { create(:user, :admin) }
  let!(:staff) { create(:user) }
  let(:admin_token) { JwtService.encode({ user_id: admin.id, role: admin.role }) }
  let(:staff_token) { JwtService.encode({ user_id: staff.id, role: staff.role }) }

  def auth_headers(token)
    { 'Authorization' => "Bearer #{token}" }
  end

  describe 'GET /api/v1/products' do
    let!(:product) { create(:product) }

    it 'ดูรายการสินค้าได้เมื่อ login แล้ว' do
      get '/api/v1/products', headers: auth_headers(admin_token)
      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body['data'].length).to eq(1)
      expect(body['meta']['total_count']).to eq(1)
    end

    it 'ไม่ได้ login → 401' do
      get '/api/v1/products'
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'POST /api/v1/products' do
    let(:valid_params) do
      { product: { name: 'MacBook', price: 50000, stock: 3, category: 'electronics' } }
    end

    it 'admin สร้างสินค้าได้' do
      post '/api/v1/products', params: valid_params, headers: auth_headers(admin_token), as: :json
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)['data']['name']).to eq('MacBook')
    end

    it 'staff สร้างสินค้าได้' do
      post '/api/v1/products', params: valid_params, headers: auth_headers(staff_token), as: :json
      expect(response).to have_http_status(:created)
    end

    it 'fail เมื่อข้อมูลผิด' do
      post '/api/v1/products',
        params: { product: { name: '', price: -1, stock: -1, category: 'xyz' } },
        headers: auth_headers(admin_token),
        as: :json
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)).to have_key('errors')
    end
  end

  describe 'DELETE /api/v1/products/:id' do
    let!(:product) { create(:product) }

    it 'admin ลบได้' do
      delete "/api/v1/products/#{product.id}", headers: auth_headers(admin_token)
      expect(response).to have_http_status(:ok)
    end

    it 'staff ลบไม่ได้ → 403' do
      delete "/api/v1/products/#{product.id}", headers: auth_headers(staff_token)
      expect(response).to have_http_status(:forbidden)
    end
  end
end

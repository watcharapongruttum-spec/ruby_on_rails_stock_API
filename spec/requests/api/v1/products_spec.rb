require 'swagger_helper'

RSpec.describe 'Products API', type: :request do

  path '/api/v1/products' do
    get 'ดูสินค้าทั้งหมด' do
      tags 'Products'
      security [{ bearerAuth: [] }]
      produces 'application/json'
      parameter name: :Authorization, in: :header, type: :string
      parameter name: :page,     in: :query, type: :integer, required: false
      parameter name: :per_page, in: :query, type: :integer, required: false

      response '200', 'สำเร็จ' do
        let(:user) { create(:user, :admin) }
        let(:Authorization) { "Bearer #{JwtService.encode({ user_id: user.id, role: user.role })}" }
        schema type: :object, properties: {
          data: { type: :array, items: { '$ref' => '#/components/schemas/Product' } },
          meta: { type: :object }
        }
        run_test!
      end

      response '401', 'ไม่ได้ login' do
        let(:Authorization) { 'Bearer invalid' }
        schema '$ref' => '#/components/schemas/Error'
        run_test!
      end
    end

    post 'สร้างสินค้า' do
      tags 'Products'
      security [{ bearerAuth: [] }]
      consumes 'application/json'
      produces 'application/json'
      parameter name: :Authorization, in: :header, type: :string
      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: {
          product: { type: :object, properties: {
            name: { type: :string }, price: { type: :number },
            stock: { type: :integer }, category: { type: :string }
          }, required: ['name', 'price', 'stock', 'category'] }
        }
      }

      response '201', 'สร้างสำเร็จ' do
        let(:user) { create(:user, :admin) }
        let(:Authorization) { "Bearer #{JwtService.encode({ user_id: user.id, role: user.role })}" }
        let(:body) { { product: { name: 'iPad', price: 25000, stock: 5, category: 'electronics' } } }
        schema type: :object, properties: { data: { '$ref' => '#/components/schemas/Product' } }
        run_test!
      end

      response '422', 'ข้อมูลไม่ถูกต้อง' do
        let(:user) { create(:user, :admin) }
        let(:Authorization) { "Bearer #{JwtService.encode({ user_id: user.id, role: user.role })}" }
        let(:body) { { product: { name: '', price: -1, stock: -1, category: 'xyz' } } }
        schema '$ref' => '#/components/schemas/Errors'
        run_test!
      end
    end
  end

  path '/api/v1/products/{id}' do
    parameter name: :Authorization, in: :header, type: :string
    parameter name: :id, in: :path, type: :integer

    get 'ดูสินค้าชิ้นเดียว' do
      tags 'Products'
      security [{ bearerAuth: [] }]
      produces 'application/json'

      response '200', 'สำเร็จ' do
        let(:user)    { create(:user, :admin) }
        let(:product) { create(:product) }
        let(:id)      { product.id }
        let(:Authorization) { "Bearer #{JwtService.encode({ user_id: user.id, role: user.role })}" }
        schema type: :object, properties: { data: { '$ref' => '#/components/schemas/Product' } }
        run_test!
      end

      response '404', 'ไม่พบสินค้า' do
        let(:user) { create(:user, :admin) }
        let(:id)   { 99999 }
        let(:Authorization) { "Bearer #{JwtService.encode({ user_id: user.id, role: user.role })}" }
        schema '$ref' => '#/components/schemas/Error'
        run_test!
      end
    end

    delete 'ลบสินค้า' do
      tags 'Products'
      security [{ bearerAuth: [] }]
      produces 'application/json'

      response '200', 'ลบสำเร็จ' do
        let(:user)    { create(:user, :admin) }
        let(:product) { create(:product) }
        let(:id)      { product.id }
        let(:Authorization) { "Bearer #{JwtService.encode({ user_id: user.id, role: user.role })}" }
        schema type: :object, properties: { message: { type: :string } }
        run_test!
      end

      response '403', 'สิทธิ์ไม่เพียงพอ' do
        let(:user)    { create(:user) }
        let(:product) { create(:product) }
        let(:id)      { product.id }
        let(:Authorization) { "Bearer #{JwtService.encode({ user_id: user.id, role: user.role })}" }
        schema '$ref' => '#/components/schemas/Error'
        run_test!
      end
    end
  end
end

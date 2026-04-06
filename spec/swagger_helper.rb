require 'rails_helper'

RSpec.configure do |config|
  config.swagger_root = Rails.root.join('swagger').to_s

  config.swagger_docs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'Stock API',
        version: 'v1',
        description: 'API สำหรับจัดการสินค้าคงคลัง'
      },
      servers: [
        { url: 'http://localhost:3000', description: 'Development' }
      ],
      components: {
        securitySchemes: {
          bearerAuth: {
            type: :http,
            scheme: :bearer,
            bearerFormat: 'JWT'
          }
        },
        schemas: {
          Product: {
            type: :object,
            properties: {
              id:         { type: :integer },
              name:       { type: :string },
              price:      { type: :number },
              stock:      { type: :integer },
              category:   { type: :string, enum: ['electronics', 'clothing', 'food', 'other'] },
              in_stock:   { type: :boolean },
              created_at: { type: :string, format: 'date-time' }
            }
          },
          User: {
            type: :object,
            properties: {
              id:         { type: :integer },
              email:      { type: :string },
              name:       { type: :string },
              role:       { type: :string, enum: ['admin', 'staff'] },
              created_at: { type: :string, format: 'date-time' }
            }
          },
          Error: {
            type: :object,
            properties: {
              error: { type: :string }
            }
          },
          Errors: {
            type: :object,
            properties: {
              errors: { type: :array, items: { type: :string } }
            }
          }
        }
      }
    }
  }

  config.swagger_format = :yaml
end

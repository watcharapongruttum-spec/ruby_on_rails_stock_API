# app/serializers/product_serializer.rb
class ProductSerializer

  def initialize(product)
    @product = product
  end

  def as_json(*)
    {
      id:         @product.id,
      name:       @product.name,
      price:      @product.price.to_f,
      stock:      @product.stock,
      category:   @product.category,
      in_stock:   @product.in_stock?,
      created_at: @product.created_at&.iso8601
    }
  end

  # สำหรับแปลงหลายรายการพร้อมกัน
  def self.collection(products)
    products.map { |p| new(p).as_json }
  end
end
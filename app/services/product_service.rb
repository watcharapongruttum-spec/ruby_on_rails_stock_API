# app/services/product_service.rb
class ProductService

  def initialize(repository = ProductRepository.new)
    @repo = repository
  end

  def list_products(filters = {})
    @repo.all(filters)
  end

  def find_product(id)
    product = @repo.find_by_id(id)
    raise ActiveRecord::RecordNotFound, "ไม่พบสินค้า id: #{id}" unless product
    product
  end

  def create_product(attributes)
    product = @repo.create(attributes)
    raise ActiveRecord::RecordInvalid.new(product) unless product.persisted?
    product
  end

  def update_product(id, attributes)
    product = find_product(id)
    @repo.update(product, attributes)
    raise ActiveRecord::RecordInvalid.new(product) unless product.errors.empty?
    product
  end

  def delete_product(id)
    product = find_product(id)
    @repo.delete(product)
  end
end
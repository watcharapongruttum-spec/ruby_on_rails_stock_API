# app/repositories/product_repository.rb
class ProductRepository
  include IProductRepository   

  def all(filters = {})
    scope = Product.all
    scope = scope.by_category(filters[:category]) if filters[:category].present?
    scope = scope.in_stock if filters[:in_stock] == 'true'
    scope.order(created_at: :desc)
  end

  def find_by_id(id)
    Product.find_by(id: id)
  end

  def create(attributes)
    Product.create(attributes)
  end

  def update(product, attributes)
    product.update(attributes)
    product
  end

  def delete(product)
    product.destroy
  end

  def exists_by_name?(name, exclude_id: nil)
    scope = Product.where('LOWER(name) = LOWER(?)', name)
    scope = scope.where.not(id: exclude_id) if exclude_id
    scope.exists?
  end
end
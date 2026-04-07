class InventoryRepository
#   include IProductRepository 
    include IInventoryRepository

  def all(filters = {})
    scope = Inventory.includes(:product)
    scope = scope.where(product_id: filters[:product_id]) if filters[:product_id]
    scope
  end

  def find_by_id(id)
    Inventory.includes(:product).find(id)
  end

  def find_by_product(product_id)
    Inventory.find_by(product_id: product_id)
  end

  def create(attributes)
    Inventory.create!(attributes)
  end

  def update(record, attributes)
    record.update!(attributes)
    record
  end

  def delete(record)
    record.destroy!
  end
end
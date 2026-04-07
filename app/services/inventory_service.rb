class InventoryService
  def initialize(repository = InventoryRepository.new)
    @repo = repository
  end

  # ──────────────────────────────────────────
  # Query
  # ──────────────────────────────────────────
  def list(filters = {})
    @repo.all(filters)
  end

  def find(id)
    @repo.find_by_id(id)
  end

  # ──────────────────────────────────────────
  # Commands
  # ──────────────────────────────────────────
  def create(attributes)
    validate_no_duplicate!(attributes[:product_id])
    @repo.create(attributes)
  end

  def adjust_stock(id, quantity)
    inventory = @repo.find_by_id(id)
    raise InventoryError, "สต็อกติดลบไม่ได้" if inventory.quantity + quantity < 0
    @repo.update(inventory, quantity: inventory.quantity + quantity)
  end

  def delete(id)
    inventory = @repo.find_by_id(id)
    @repo.delete(inventory)
  end

  private

  def validate_no_duplicate!(product_id)
    existing = @repo.find_by_product(product_id)
    raise "Product นี้มี Inventory อยู่แล้ว" if existing
  end
end
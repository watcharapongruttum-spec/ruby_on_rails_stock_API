# app/serializers/inventory_serializer.rb
class InventorySerializer
  def initialize(inventory)
    @inventory = inventory
  end

  def as_json(*)
    {
      id:         @inventory.id,
      quantity:   @inventory.quantity,
      status:     status,
      product_id: @inventory.product_id,
      product:    product_info,
      created_at: @inventory.created_at&.iso8601,
      updated_at: @inventory.updated_at&.iso8601
    }
  end

  def self.collection(inventories)
    inventories.map { |i| new(i).as_json }
  end

  private

  def status
    if @inventory.out_of_stock?
      'out_of_stock'
    elsif @inventory.low_stock?
      'low_stock'
    else
      'in_stock'
    end
  end

  def product_info
    return nil unless @inventory.product
    { id: @inventory.product.id, name: @inventory.product.name }
  end
end

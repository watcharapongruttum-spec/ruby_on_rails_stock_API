class CreateInventoryForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  # ──────────────────────────────────────────
  # Fields
  # ──────────────────────────────────────────
  attribute :product_id, :integer
  attribute :quantity,   :integer

  # ──────────────────────────────────────────
  # Validations
  # ──────────────────────────────────────────
  validates :product_id, presence: true
  validates :quantity,   presence: true,
                         numericality: { greater_than_or_equal_to: 0 }

  # ──────────────────────────────────────────
  # Output
  # ──────────────────────────────────────────
  def to_attributes
    {
      product_id: product_id,
      quantity:   quantity
    }
  end
end
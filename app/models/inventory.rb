class Inventory < ApplicationRecord

  # ──────────────────────────────────────────
  # Associations
  # ──────────────────────────────────────────
  belongs_to :product

  # ──────────────────────────────────────────
  # Domain Rules
  # ──────────────────────────────────────────
  validates :quantity, presence: true,numericality: { greater_than_or_equal_to: 0 }

  # ──────────────────────────────────────────
  # Domain Methods
  # ──────────────────────────────────────────
  def low_stock?
    quantity < 10
  end

  def out_of_stock?
    quantity == 0
  end
end
# app/models/product.rb
class Product < ApplicationRecord

  # ──────────────────────────────────────────
  # Associations
  # ──────────────────────────────────────────
  has_many :sale_items
  has_many :sales, through: :sale_items
  has_many :purchase_items
  has_many :purchases, through: :purchase_items
  has_many :inventories


  # ──────────────────────────────────────────
  # Domain Rules (กฎที่ต้องเคารพเสมอ)
  # ──────────────────────────────────────────
  validates :name,     presence: true, length: { maximum: 100 }
  validates :price,    presence: true, numericality: { greater_than: 0 }
  validates :stock,    presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :category, presence: true, inclusion: { in: ProductCategory::ALL }
  validates :name,     uniqueness: { case_sensitive: false }

  # ──────────────────────────────────────────
  # Scopes (ช่วยค้นหา — ยังอยู่ใน Domain)
  # ──────────────────────────────────────────
  scope :in_stock,      -> { where('stock > 0') }
  scope :out_of_stock,  -> { where(stock: 0) }
  scope :by_category,   ->(cat) { where(category: cat) }

  # ──────────────────────────────────────────
  # Domain Methods (logic ของ Entity เอง)
  # ──────────────────────────────────────────
  def in_stock?
    stock > 0
  end

  def reduce_stock!(quantity)
    raise "สต็อกไม่เพียงพอ" if stock < quantity
    update!(stock: stock - quantity)
  end
end
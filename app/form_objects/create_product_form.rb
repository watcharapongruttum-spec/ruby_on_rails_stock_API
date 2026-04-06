class CreateProductForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :name,     :string
  attribute :price,    :decimal
  attribute :stock,    :integer
  attribute :category, :string

  validates :name,     presence: true, length: { maximum: 100 }
  validates :price,    presence: true, numericality: { greater_than: 0 }
  validates :stock,    presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :category, presence: true, inclusion: { in: ProductCategory::ALL }

  def to_h
    { name: name, price: price, stock: stock, category: category }
  end
end

class UpdateProductForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :name,     :string
  attribute :price,    :decimal
  attribute :stock,    :integer
  attribute :category, :string

  validates :name,     length: { maximum: 100 }, allow_blank: true
  validates :price,    numericality: { greater_than: 0 }, allow_nil: true
  validates :stock,    numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :category, inclusion: { in: ProductCategory::ALL }, allow_blank: true

  def to_h
    {}.tap do |h|
      h[:name]     = name     if name.present?
      h[:price]    = price    if price.present?
      h[:stock]    = stock    unless stock.nil?
      h[:category] = category if category.present?
    end
  end
end

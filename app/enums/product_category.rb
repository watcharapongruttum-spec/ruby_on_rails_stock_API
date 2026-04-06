module ProductCategory
  ALL = %w[electronics clothing food other].freeze

  ELECTRONICS = 'electronics'
  CLOTHING    = 'clothing'
  FOOD        = 'food'
  OTHER       = 'other'

  def self.valid?(value)
    ALL.include?(value.to_s)
  end

  def self.options
    ALL.map { |c| { value: c, label: c.capitalize } }
  end
end
class Money
  include Comparable

  attr_reader :amount

  def initialize(amount)
    raise ArgumentError, 'ราคาต้องเป็นตัวเลข' unless amount.is_a?(Numeric)
    raise ArgumentError, 'ราคาต้องมากกว่า 0'  unless amount > 0
    @amount = amount.to_d
  end

  def <=>(other)
    amount <=> other.amount
  end

  def to_f
    amount.to_f
  end

  def to_s
    "฿#{format('%.2f', amount)}"
  end
end
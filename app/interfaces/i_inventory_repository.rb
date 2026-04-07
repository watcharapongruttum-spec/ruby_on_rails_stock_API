module IInventoryRepository

  # ──────────────────────────────────────────
  # Query Methods
  # ──────────────────────────────────────────
  def all(filters = {})
    raise NotImplementedError, "#{self.class}#all ยังไม่ได้ implement"
  end

  def find_by_id(id)
    raise NotImplementedError, "#{self.class}#find_by_id ยังไม่ได้ implement"
  end

  def find_by_product(product_id)
    raise NotImplementedError, "#{self.class}#find_by_product ยังไม่ได้ implement"
  end

  # ──────────────────────────────────────────
  # Command Methods
  # ──────────────────────────────────────────
  def create(attributes)
    raise NotImplementedError, "#{self.class}#create ยังไม่ได้ implement"
  end

  def update(record, attributes)
    raise NotImplementedError, "#{self.class}#update ยังไม่ได้ implement"
  end

  def delete(record)
    raise NotImplementedError, "#{self.class}#delete ยังไม่ได้ implement"
  end
end
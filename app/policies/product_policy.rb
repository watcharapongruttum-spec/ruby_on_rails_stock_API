class ProductPolicy

  def initialize(user)
    @user = user
  end

  def can_view?
    true
  end

  def can_create?
    admin? || staff?
  end

  def can_update?
    admin? || staff?
  end

  def can_delete?
    admin?
  end

  private

  def admin?
    @user&.role == 'admin'
  end

  def staff?
    @user&.role == 'staff'
  end
end

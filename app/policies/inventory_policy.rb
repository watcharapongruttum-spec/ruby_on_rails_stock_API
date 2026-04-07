class InventoryPolicy

  def initialize(user)
    @user = user
  end

  # ──────────────────────────────────────────
  # Permissions
  # ──────────────────────────────────────────
  def index?
    admin? || staff?
  end

  def show?
    admin? || staff?
  end

  def create?
    admin?
  end

  def adjust?
    admin? || staff?
  end

  def destroy?
    admin?
  end

  private

  def admin?
    @user&.admin?
  end

  def staff?
    @user&.staff?
  end
end
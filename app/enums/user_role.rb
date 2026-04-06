module UserRole
  ALL   = %w[admin staff].freeze
  ADMIN = 'admin'
  STAFF = 'staff'

  def self.valid?(value)
    ALL.include?(value.to_s)
  end
end
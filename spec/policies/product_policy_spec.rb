require 'rails_helper'

RSpec.describe ProductPolicy do
  let(:admin) { build(:user, :admin) }
  let(:staff) { build(:user) }

  describe '#can_view?' do
    it 'admin ดูได้' do
      expect(ProductPolicy.new(admin).can_view?).to be true
    end

    it 'staff ดูได้' do
      expect(ProductPolicy.new(staff).can_view?).to be true
    end
  end

  describe '#can_create?' do
    it 'admin สร้างได้' do
      expect(ProductPolicy.new(admin).can_create?).to be true
    end

    it 'staff สร้างได้' do
      expect(ProductPolicy.new(staff).can_create?).to be true
    end
  end

  describe '#can_delete?' do
    it 'admin ลบได้' do
      expect(ProductPolicy.new(admin).can_delete?).to be true
    end

    it 'staff ลบไม่ได้' do
      expect(ProductPolicy.new(staff).can_delete?).to be false
    end
  end
end

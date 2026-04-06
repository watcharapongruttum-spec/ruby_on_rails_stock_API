require 'rails_helper'

RSpec.describe CreateProductForm do
  let(:valid_attrs) do
    { name: 'iPhone 15', price: 35000, stock: 5, category: 'electronics' }
  end

  describe 'valid data' do
    it 'ผ่านเมื่อข้อมูลถูกต้อง' do
      form = CreateProductForm.new(valid_attrs)
      expect(form).to be_valid
    end
  end

  describe 'invalid data' do
    it 'fail เมื่อไม่มีชื่อ' do
      form = CreateProductForm.new(valid_attrs.merge(name: ''))
      expect(form).not_to be_valid
      expect(form.errors[:name]).to include("can't be blank")
    end

    it 'fail เมื่อราคาติดลบ' do
      form = CreateProductForm.new(valid_attrs.merge(price: -1))
      expect(form).not_to be_valid
      expect(form.errors[:price]).to include('must be greater than 0')
    end

    it 'fail เมื่อ stock ติดลบ' do
      form = CreateProductForm.new(valid_attrs.merge(stock: -1))
      expect(form).not_to be_valid
    end

    it 'fail เมื่อ category ไม่อยู่ใน list' do
      form = CreateProductForm.new(valid_attrs.merge(category: 'xyz'))
      expect(form).not_to be_valid
      expect(form.errors[:category]).to include('is not included in the list')
    end
  end

  describe '#to_h' do
    it 'คืน hash ที่ถูกต้อง' do
      form = CreateProductForm.new(valid_attrs)
      expect(form.to_h).to eq({
        name: 'iPhone 15',
        price: BigDecimal('35000'),
        stock: 5,
        category: 'electronics'
      })
    end
  end
end

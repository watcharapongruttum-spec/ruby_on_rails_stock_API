# db/migrate/XXXXXX_create_products.rb
class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string  :name,     null: false
      t.decimal :price,    null: false, precision: 10, scale: 2
      t.integer :stock,    null: false, default: 0
      t.string  :category, null: false

      t.timestamps  # สร้าง created_at, updated_at ให้อัตโนมัติ
    end

    add_index :products, :name
    add_index :products, :category
  end
end
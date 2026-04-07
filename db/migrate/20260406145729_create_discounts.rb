class CreateDiscounts < ActiveRecord::Migration[7.0]
  def change
    create_table :discounts do |t|
      t.string :name, null: false
      t.string :discount_type, null: false
      t.decimal :value, null: false, precision: 10, scale: 2

      t.timestamps
    end
  end
end

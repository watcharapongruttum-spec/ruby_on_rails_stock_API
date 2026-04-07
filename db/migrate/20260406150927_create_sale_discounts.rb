class CreateSaleDiscounts < ActiveRecord::Migration[7.0]
  def change
    create_table :sale_discounts do |t|
      t.references :sale, null: false, foreign_key: true
      t.references :discount, null: false, foreign_key: true

      t.timestamps
    end
  end
end
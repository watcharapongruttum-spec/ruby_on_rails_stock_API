class CreatePurchases < ActiveRecord::Migration[7.0]
  def change
    create_table :purchases do |t|
      t.references :supplier, null: false, foreign_key: true
      t.string :status, null: false, default: 'pending'
      t.decimal :total_price, precision: 10, scale: 2, null: false, default: 0

      t.timestamps
    end
  end
end
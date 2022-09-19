class CreateSoldProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :sold_products do |t|
      t.integer :product_id
      t.string :quantity
      t.integer :actual_price
      t.integer :actual_tax
      t.float :purchased_price
      t.float :purchased_tax
      t.float :total_price
      t.references :bill, null: false, foreign_key: true

      t.timestamps
    end
  end
end

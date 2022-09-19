class CreateBills < ActiveRecord::Migration[6.1]
  def change
    create_table :bills do |t|
      t.string :customer_email
      t.string :cash_paid_by_customer
      t.integer :sold_products_count
      t.integer :total_price
      t.string :manual_denominations

      t.timestamps
    end
  end
end

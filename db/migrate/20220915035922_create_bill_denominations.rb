class CreateBillDenominations < ActiveRecord::Migration[6.1]
  def change
    create_table :bill_denominations do |t|
      t.integer :amount
      t.integer :count
      t.integer :bill_id

      t.timestamps
    end
  end
end

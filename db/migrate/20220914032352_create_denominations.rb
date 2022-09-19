class CreateDenominations < ActiveRecord::Migration[6.1]
  def change
    create_table :denominations do |t|
      t.integer :amount
      t.integer :count

      t.timestamps
    end
  end
end

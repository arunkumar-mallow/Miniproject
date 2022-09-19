class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :name
      t.integer :available_quantity
      t.integer :price
      t.integer :tax

      t.timestamps
    end
  end
end

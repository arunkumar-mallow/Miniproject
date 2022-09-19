class SoldProduct < ApplicationRecord
  belongs_to :product
  belongs_to :bill, optional: true, counter_cache: true

  validates :product_id, presence: true
  validates :quantity, presence: true

  before_create do
    product = Product.find(self.product_id)
    self.actual_price = product.price
    self.actual_tax = product.tax
    self.purchased_price = product.price.to_f * self.quantity.to_f
    self.purchased_tax = self.purchased_price / 100 * product.tax.to_f
    self.total_price = self.purchased_price + self.purchased_tax

  end
end

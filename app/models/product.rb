class Product < ApplicationRecord
  has_many :sold_products
  has_many :bills, through: :sold_products
end

class Bill < ApplicationRecord
  has_many :sold_products, dependent: :destroy
  has_many :bill_denomination

  accepts_nested_attributes_for :sold_products, allow_destroy: true

  validates :customer_email, presence: true
  validates :cash_paid_by_customer, presence: true
  validates :total_price, presence: true
  validates_each :cash_paid_by_customer do |record, message, value|
    unless record.total_price <= value.to_i
      record.errors.add(message, "Insufficient amount")
    end
  end

  before_create do
    denominations = Denomination.order("amount DESC")
    denominations.each do |denomination|
      bill_id = 0
      bill_id = Bill.last.id.to_i + 1 if Bill.last.present?
      BillDenomination.create! amount: denomination.amount, count: denomination.count, bill_id: bill_id
    end

  end

  after_create do

    hash = {}
    denominations = Denomination.all
    denominations.each { |denomination| hash[denomination.amount.to_i] = denomination.count.to_i}
    d = ApplicationController.helpers.denominations_return(self.total_price.to_i, self.cash_paid_by_customer.to_i, hash, ApplicationController.helpers.denominations_string_to_hash(self.manual_denominations))

    d.each do |amount, count|
      next if amount == "remaining_amount"
      Denomination.find_by_amount(amount).update(count: count)
    end

  end
end

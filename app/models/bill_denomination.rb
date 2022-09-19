class BillDenomination < ApplicationRecord
  belongs_to :bill, optional: true
end

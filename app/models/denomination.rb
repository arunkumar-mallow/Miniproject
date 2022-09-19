class Denomination < ApplicationRecord

  validates :amount, uniqueness: true

  before_destroy do
    if count > 0
      throw :abort
    end

  end
end

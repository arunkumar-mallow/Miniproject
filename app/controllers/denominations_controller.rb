class DenominationsController < ApplicationController
  def index
    @denominations = Denomination.order("amount DESC")
  end

  def create
    Denomination.create! amount: params["denomination"]["amount"].to_i, count: 0
    redirect_to request.referrer

  end

  def update
    params.each do |amount, count|
      if amount[0..12] == "denomination_"
        Denomination.find_by_amount(amount[13..]).update(count: count.to_i)
      end
    end
    redirect_to request.referrer
  end

  def destroy
    Denomination.find(params[:id]).destroy
    redirect_to request.referrer
  end

  private

  def denomination_params
    params.require(:denomination).permit(:d500, :d100, :d50, :d20, :d10, :d1)
  end
end
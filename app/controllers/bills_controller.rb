class BillsController < ApplicationController
  def index
    @bills = Bill.all.order("id DESC")

    if params[:commit] == "Search"
      unless params[:email_id] == ""
        @bills = @bills.where("customer_email LIKE ?", "%#{params[:email_id]}%")
      end

      unless params[:from_date] == "" or params[:to_date] == ""
        @bills = @bills.where("created_at between ? and ? ", params[:from_date], params[:to_date])
      end
    end
  end

  def get_price
    total_price = 0
    sold_products = params[:bill][:sold_products_attributes]
    sold_products.each do |key, value|
      product_id = value[:product_id]
      quantity = value[:quantity]

      product = Product.find(product_id)
      total_price += product.price.to_i * quantity.to_i + product.tax.to_i * quantity.to_i
    end

    @total_price = total_price
  end

  def manual_denominations
    d = params[:bill]
    hash = {}
    d.each { |key, value| hash[key.remove("md").to_i] = value if key.include?("md") }
    @price = ApplicationController.helpers.denominations_price(hash)
  end

  def new
    redirect_to denominations_path if Denomination.all.count == 0
    @bill = Bill.new
    @bill.sold_products.build
    @denominations = Denomination.order("amount DESC")
  end

  def show
    @bill = Bill.find(params[:id])
    @sold_products = @bill.sold_products
  end

  def create
    manual_denominations = ""
    given = false
    params["bill"].each do |key, value|
      if key.include?("md")
        manual_denominations += "#{key.remove("md")}:#{value},"
        given = true unless value == "0"
      end
    end

    manual_denominations = "0." unless given

    params["bill"]["manual_denominations"] = manual_denominations[0..-2]

    @bill = Bill.new(bill_params)

    respond_to do |format|
      if @bill.save
        format.html { redirect_to bill_path(@bill), notice: "Bill Generated Successfully" }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  private

  def bill_params
    params.require(:bill).permit(:customer_email, :cash_paid_by_customer, :total_price, :manual_denominations,
                                 sold_products_attributes: [:product_id, :quantity])
  end
end
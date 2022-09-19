class ProductsController < ApplicationController
  def index
    @products = Product.all

    if params[:commit] == "Search" and params[:product_name] != ""
      @products = @products.where("name LIKE ?", "%#{params[:product_name]}%")
    end
  end

  def new
    @product = Product.new
  end

  def edit
    @product = Product.find(params[:id])
  end

  def show
    @product = Product.find(params[:id])

  end

  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to product_path(@product), notice: "Bill Generated Successfully" }
      else
        format.html { render :index, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    Product.find(params[:id]).destroy
    redirect_to request.referrer
  end

  private

  def product_params
    params.require(:product).permit(:name, :price, :tax, :available_quantity)
  end
end

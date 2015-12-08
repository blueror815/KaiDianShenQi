class Api::V1::ProductsController < ApplicationController
  before_action :authenticate_with_token!, only: [:index, :show, :destroy]
  respond_to :json

  def create
    logger.debug("Parameter for product controller create is" + product_params.to_json)
    product = current_oauth_retailer.products.build(product_params)
    if product.save
      render json: product, status: 201, format: :json
    else
      render json: {errors: product.errors}, status: 422, format: :json
    end
  end

  def show
    respond_with current_oauth_retailer.products.find_by(id: params[:id])
  end

  def index
    products = current_oauth_retailer.products
    respond_with products, format: :json
  end


  def update
    product = current_oauth_retailer.products.find_by(product_params[:id])
    if product.update(product_params)
      render json: product, status: 200#, location: [:api, product]
    else
      render json: {errors: product.errors}, status: 422
    end
  end

  def destroy
    product = current_oauth_retailer.products.find_by(id: params[:id])

    if product
      product.destroy
      head 204
    else
      head 422
    end
  end

  private
  def product_params
    params.require(:product).permit(:title, :price, :barcode, :description, :quantity_in_stock, :point_value)#.require(:price)
  end
end

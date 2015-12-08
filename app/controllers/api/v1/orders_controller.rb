class Api::V1::OrdersController < ApplicationController
  before_action :authenticate_with_token!, only: [:create, :show, :index]
  respond_to :json

  def create
    order = Order.new
    checkout_result_order = order.checkout_cash(current_oauth_retailer, params[:order][:product_ids_with_quantities], order_params[:member_external_id])
    if checkout_result_order.is_a?(Hash)
      render json: checkout_result_order, status: 422
    else
      render json: checkout_result_order, status: 201
    end
  end

  def create_points_order
    order = Order.new
    checkout_result_order = order.checkout_points(current_oauth_retailer, params[:order][:product_ids_with_quantities], order_params[:member_external_id])
    if checkout_result_order.is_a?(Hash)
      render json: checkout_result_order, status: 422
    else
      render json: checkout_result_order, status: 201
    end
  end

  def index
    orders = current_oauth_retailer.orders
    render json: orders, status: 200
  end

  def show
    order =  current_oauth_retailer.orders.find_by(id: params[:id])
    render json: order, status: 200
  end


  private
    def order_params
      params.require(:order).permit(:retailer_id, :member_external_id)
    end
end

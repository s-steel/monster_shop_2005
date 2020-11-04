class Profile::OrdersController < ApplicationController

  def index
  end

  def update
    @order = Order.find(params[:id])
    @order.cancel_order
    @order.unfulfill_items
    @order.save
    flash[:success] = "Your order has been cancelled."
    redirect_to "/profile"
  end
end

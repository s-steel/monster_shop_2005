class Profile::OrdersController < ApplicationController

  def index
  end

  def update

    @order = Order.find(params[:id])
    # require "pry"; binding.pry
    @order.cancel_order
    @order.unfulfill_items
    # @order.save!
    # @order.update(
    #   status: "cancelled")
    # @order.status = 'cancelled'
    @order.save
      # require "pry"; binding.pry
    # @order.save
    # require "pry"; binding.pry
    flash[:success] = "Your order has been cancelled."
    redirect_to "/profile"
    # require "pry"; binding.pry
  end
end

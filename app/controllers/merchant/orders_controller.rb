class Merchant::OrdersController < ApplicationController
  before_action :require_merchant

  def show
    @user = current_user
    @order = Order.find(params[:order_id])
  end

  def update

    case params[:todo]
    when 'fulfill'

      item_order = ItemOrder.find(params[:item_order])
      if item_order.item.inventory >= item_order.quantity
        item_order.fulfill
        item_order.item.inventory -= item_order.quantity
        item_order.item.save
        flash[:success] = 'Item fulfilled!'
      end
      redirect_to merchant_order_path(item_order.order.id)
    end
  end

  private

  def require_merchant
    render file: '/public/404' unless current_merchant?
  end
end

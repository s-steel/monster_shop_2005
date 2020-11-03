class Merchant::OrdersController < ApplicationController
  before_action :require_merchant

  def show
    @user = current_user
    @order = Order.find(params[:order_id])
  end

private
  def require_merchant
    render file: "/public/404" unless current_merchant?
  end
end

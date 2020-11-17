class Admin::DashboardController < ApplicationController
  before_action :require_admin

  def index
    @orders = Order.all
  end

  def ship
    order = Order.find(params[:id])
    order.update(status: 'shipped')
    redirect_to '/admin'
  end

private
  def require_admin
    render file: "/public/404" unless current_admin?
  end
end

class Admin::MerchantsController < ApplicationController
  before_action :require_admin

  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find(params[:id])
  end

  def disable
    merchant = Merchant.find(params[:id])
    merchant.toggle_active
    merchant.items.update_all(active?: false)
    merchant.save
    flash[:notice] = "#{merchant.name} is now disabled"

    redirect_to "/admin/merchants"
  end

  def enable
    merchant = Merchant.find(params[:id])
    merchant.toggle_active
    # merchant.items.update_all(active?: false)
    merchant.save
    flash[:notice] = "#{merchant.name} is now enabled"

    redirect_to "/admin/merchants"
  end

private
  def require_admin
    render file: "/public/404" unless current_admin?
  end
end

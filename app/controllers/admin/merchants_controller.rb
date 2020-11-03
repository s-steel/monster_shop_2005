class Admin::MerchantsController < ApplicationController
  before_action :require_admin

  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find(params[:id])
  end

  def update
    merchant = Merchant.find(params[:id])
    merchant.toggle_active
    if merchant.active? == false
      flash[:notice] = "#{merchant.name} is now disabled"
    else
      flash[:notice] = "#{merchant.name} is now active"
    end 
  end

private
  def require_admin
    render file: "/public/404" unless current_admin?
  end
end

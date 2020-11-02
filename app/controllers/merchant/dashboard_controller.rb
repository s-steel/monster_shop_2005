class Merchant::DashboardController < ApplicationController
  before_action :require_merchant

  def show
    @user = current_user
    @merchant = Merchant.find(@user[:merchant_id])
  end

private
  def require_merchant
    render file: "/public/404" unless current_merchant?
  end
end

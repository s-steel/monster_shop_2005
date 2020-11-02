class Merchant::ItemsController < ApplicationController
  before_action :require_merchant

  def index
    user = current_user
    @merchant = Merchant.find(user[:merchant_id])
  end

private
  def require_merchant
    render file: "/public/404" unless current_merchant?
  end
end

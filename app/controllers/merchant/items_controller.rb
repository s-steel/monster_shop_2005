class Merchant::ItemsController < ApplicationController
  before_action :require_merchant

  def index
    user = current_user
    @merchant = Merchant.find(user[:merchant_id])
  end

  def destroy
    item = Item.find(params[:id])
    item.destroy
    flash[:success] = "Item successfully deleted."
    redirect_to "/merchant/items"
  end

  def deactivate
    item = Item.find(params[:id])
    item.update(active?: false)
    item.save
    flash[:notice] = "#{item.name} is no longer for sale"

    redirect_to "/merchant/items"
  end

  def activate
    item = Item.find(params[:id])
    item.update(active?: true)
    item.save
    flash[:notice] = "#{item.name} is now available for sale"

    redirect_to "/merchant/items"
  end

private
  def require_merchant
    render file: "/public/404" unless current_merchant?
  end
end

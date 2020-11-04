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
    item.toggle_active
    item.save
    flash[:notice] = "#{item.name} is no longer for sale"

    redirect_to "/merchant/items"
  end

  def activate
    item = Item.find(params[:id])
    item.toggle_active
    item.save
    flash[:notice] = "#{item.name} is now available for sale"

    redirect_to "/merchant/items"
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    item = Item.find(params[:id])
    item.update(item_params)
    if item.save
      flash[:message] = 'Your item has been updated'
      redirect_to '/merchant/items'
    else
      flash[:error] = item.errors.full_messages.to_sentence
      render :edit
    end
  end

private
  def require_merchant
    render file: "/public/404" unless current_merchant?
  end

  def item_params
    params.require(:item).permit(:name,:description,:price,:inventory,:image)
    .with_defaults(image: 'https://us.123rf.com/450wm/pavelstasevich/pavelstasevich1811/pavelstasevich181101065/112815953-stock-vector-no-image-available-icon-flat-vector.jpg?ver=6')
  end
end

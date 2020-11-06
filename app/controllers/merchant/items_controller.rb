class Merchant::ItemsController < ApplicationController
  before_action :require_merchant

  def index
    user = current_user
    @merchant = Merchant.find(user[:merchant_id])
  end

  def new
    user = current_user
    @item = user.merchant.items.new
  end

  def create
    user = current_user
    @item = user.merchant.items.new(item_params)
    if @item.image.empty?
      @item[:image] = 'https://snellservices.com/wp-content/uploads/2019/07/image-coming-soon.jpg'
    end
    if @item.inventory == 0
      flash[:error] = 'Inventory must be greater than zero.'
      redirect_to '/merchant/items/new'
      return
    end

    begin
      @item.save!
      flash[:success] = 'Item added successfully!'
      redirect_to '/merchant/items'
    rescue ActiveRecord::RecordInvalid => e
      create_error_response(e)
      render :new
    end
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
    if item.inventory < 0
      flash[:error] = 'Inventory cannot be below 0.'
      redirect_to "/merchant/items/#{item.id}/edit"
      return
    end
    if params[:item][:image] == ""
      item[:image] = 'https://snellservices.com/wp-content/uploads/2019/07/image-coming-soon.jpg'
    end

    begin
      item.save!
      flash[:message] = 'Your item has been updated'
      redirect_to '/merchant/items'
    rescue ActiveRecord::RecordInvalid => e
      create_error_response(e)
      redirect_to "/merchant/items/#{item.id}/edit"
    end
  end

private

  def require_merchant
    render file: "/public/404" unless current_merchant?
  end

  def item_params
    params.require(:item).permit(:name,:description,:price,:inventory,:image)
  end

  def create_error_response(error)
      flash[:error] = error.message.delete_prefix('Validation failed: ')
  end
end

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
    @item = user.merchant.items.create(item_params)
    if @item.image == nil
      @item[:image] = params[:item][:image]
    else
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
    if params[:item][:image] == ""
      item[:image] = 'https://snellservices.com/wp-content/uploads/2019/07/image-coming-soon.jpg'
    end
    if item.save
      flash[:message] = 'Your item has been updated'
      redirect_to '/merchant/items'
    else
      flash[:error] = item.errors.full_messages.to_sentence
      redirect_to "/merchant/items/#{item.id}/edit"
    end
  end

private

  def require_merchant
    render file: "/public/404" unless current_merchant?
  end

  def item_params
    params.require(:item).permit(:name,:description,:price,:inventory)
  end

  def create_error_response(error)
    case error.message
    when "Validation failed: Name can't be blank"
      flash.now[:error] = 'Name cannot be blank.'
    when "Validation failed: Description can't be blank"
      flash[:error] = 'Description cannot be blank.'
    when 'Validation failed: Price must be greater than 0'
      flash[:error] = 'Price must be greater than $0.00'
    end
  end
end

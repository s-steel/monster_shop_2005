class CartController < ApplicationController
  before_action :deny_admin

  def add_item
    item = Item.find(params[:item_id])
    cart.add_item(item.id.to_s)
    flash[:success] = "#{item.name} was successfully added to your cart"
    redirect_to '/items'
  end

  def show
    @items = cart.items
  end

  def empty
    session.delete(:cart)
    redirect_to '/cart'
  end

  def remove_item
    session[:cart].delete(params[:item_id])
    redirect_to '/cart'
  end

  def change_amount
    item = Item.find(params[:item_id])
    case params[:direction]
    when 'increase'

      if cart[item.id.to_s] < item.inventory
        cart[item.id.to_s] += 1
      else
        flash[:error] = 'There are no more items in stock!'
      end
      redirect_to '/cart'

    when 'decrease'

      cart[item.id.to_s] -= 1
      if cart[item.id.to_s] <= 0
        remove_item
      end
    end
  end

  private

  def deny_admin
    render file: '/public/404' if current_admin?
  end
end

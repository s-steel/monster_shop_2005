class Order < ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip

  has_many :item_orders
  has_many :items, through: :item_orders
  belongs_to :user

  enum status: %w[pending packaged shipped cancelled]

  def status_update
    if (status == 'pending') && item_orders.where('status = 0 OR status = 1').length.zero?
      update(status: 1)
    elsif (status == 'packaged') && !item_orders.where('status = 0 OR status = 1').length.zero?
      update(status: 0)
    end
  end

  def add_item(item, amount = 1)
    item_orders.create(item: item, price: item.price, quantity: amount)
  end

  def grandtotal
    item_orders.sum('price * quantity')
  end

  def item_count
    item_orders.sum(:quantity)
  end

  def date_created
    created_at.strftime('%m/%d/%Y')
  end

  def date_updated
    updated_at.strftime('%m/%d/%Y')
  end

  def cancel_order
    self.status = 3
  end

  def unfulfill_items
    item_orders.each do |item_order|
      item_order.status = 'unfulfilled'
    end
  end

  def merchant_items(merch_id)
    items.where(merchant_id: merch_id)
  end

  def total_sales(merch_id)
    merchant_items(merch_id).sum('item_orders.quantity * item_orders.price')
  end

  def merchant_item_count(merch_id)
    item_orders.joins(:item).where(items: { merchant_id: merch_id }).sum(:quantity)
  end
end

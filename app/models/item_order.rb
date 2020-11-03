class ItemOrder <ApplicationRecord
  validates_presence_of :item_id, :order_id, :price, :quantity

  belongs_to :item
  belongs_to :order

  enum status: %w(pending unfulfilled fulfilled)

  def fulfill
    update(status: 2)
    order.status_update
  end

  def unfulfill
    update(status: 1)
    order.status_update
  end

  def subtotal
    price * quantity
  end
end

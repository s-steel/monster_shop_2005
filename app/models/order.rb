class Order <ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip

  has_many :item_orders
  has_many :items, through: :item_orders
  belongs_to :user

  enum status: %w(pending packaged shipped cancelled)

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

  def total_item_count
    self.item_orders.sum(:quantity)
  end
end

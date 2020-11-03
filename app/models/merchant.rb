class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :item_orders, through: :items
  has_many :users

  validates_presence_of :name,
                        :address,
                        :city,
                        :state,
                        :zip

  def no_orders?
    item_orders.empty?
  end

  def item_count
    items.count
  end

  def average_item_price
    items.average(:price)
  end

  def distinct_cities
    item_orders.distinct.joins(:order).pluck(:city)
  end

  def top_item_amounts
    top_item_counts = item_orders.joins(:item)
                                 .group('items.id')
                                 .order('SUM(item_orders.quantity) DESC')
                                 .limit(5)
                                 .pluck('items.name, SUM(item_orders.quantity)')

    top_item_counts.each_with_object({}) do |input, obj|
      obj[input[0]] = input[1]
    end
  end
end

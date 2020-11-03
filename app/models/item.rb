class Item <ApplicationRecord
  belongs_to :merchant
  has_many :reviews, dependent: :destroy
  has_many :item_orders
  has_many :orders, through: :item_orders

  validates_presence_of :name,
                        :description,
                        :price,
                        :image,
                        :inventory
  validates_inclusion_of :active?, :in => [true, false]
  validates_numericality_of :price, greater_than: 0


  def average_review
    reviews.average(:rating)
  end

  def sorted_reviews(limit, order)
    reviews.order(rating: order).limit(limit)
  end

  def no_orders?
    item_orders.empty?
  end

  def self.best_item_stats(limit)
    select("items.*, sum(item_orders.quantity) as total_quantity").joins(:item_orders).group(:id).order("total_quantity DESC").limit(limit)
  end

  def self.worst_item_stats(limit)
    select("items.*, sum(item_orders.quantity) as total_quantity").joins(:item_orders).group(:id).order("total_quantity").limit(limit)
  end

  def toggle_active
    toggle(:active?)
  end
end

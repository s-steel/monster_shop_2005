class AddStatusToItemOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :item_orders, :status, :integer, default: 0
  end
end

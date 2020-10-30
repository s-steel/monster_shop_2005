class AddOrdersToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :user_id, :bigint
    add_foreign_key :orders, :users
  end
end

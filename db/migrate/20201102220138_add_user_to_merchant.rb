class AddUserToMerchant < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :merchant_id, :bigint
    add_foreign_key :users, :merchants
  end
end

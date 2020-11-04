class ChangeColumnDefaultItems < ActiveRecord::Migration[5.2]
  def change
    change_column_default :items, :image, nil
  end
end

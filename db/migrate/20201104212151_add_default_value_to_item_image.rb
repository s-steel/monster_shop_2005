class AddDefaultValueToItemImage < ActiveRecord::Migration[5.2]
  def change
    change_column :items, :image, :string, default: "https://snellservices.com/wp-content/uploads/2019/07/image-coming-soon.jpg"
  end
end

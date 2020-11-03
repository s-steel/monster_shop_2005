# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Merchant.destroy_all
Item.destroy_all

# merchants
bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80_210)

# bike_shop items
tire = bike_shop.items.create(name: 'Gatorskins', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)

# dog_shop items
pull_toy = dog_shop.items.create(name: 'Pull Toy', description: 'Great pull toy!', price: 10, image: 'http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg', inventory: 32)
dog_bone = dog_shop.items.create(name: 'Dog Bone', description: "They'll love it!", price: 21, image: 'https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg', active?: false, inventory: 21)


# @mike = Merchant.create(name: "Mikemart", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)

# @user = User.create!(name: 'Harold Guy',
#                      address: '123 Macho St',
#                      city: 'Lakewood',
#                      state: 'CO',
#                      zip: '80328',
#                      email: 'jyddedharrold@email.com',
#                      password: 'luggagecombo')

# @mike_user = User.create!(name: 'Mike Guy',
#                           address: '123 Macho St',
#                           city: 'Lakewood',
#                           state: 'CO',
#                           zip: '80328',
#                           email: 'mikelol@email.com',
#                           password: 'luggagecombo',
#                           role: 1,
#                           merchant_id: bike_shop.id)

# allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@mike_user)

# @tire = @mike.items.create(name: 'Gatorskins', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)
# @paper = @mike.items.create(name: 'Lined Paper', description: 'Great for writing on!', price: 20, image: 'https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png', inventory: 3)
# @pencil = @mike.items.create(name: 'Pencil', description: 'You can write on paper with it!', price: 2, image: 'https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg', inventory: 100)
# @pen = @mike.items.create(name: 'Yellow Pen', description: 'You can write on paper with it!', price: 2, image: 'https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg', inventory: 100)
# @inkwell = @mike.items.create(name: 'Yellow Inkwell', description: 'You can write on paper with it!', price: 4, image: 'https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg', inventory: 100)
# @lead = @mike.items.create(name: 'Yellow Lead', description: 'You can write on paper with it!', price: 1, image: 'https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg', inventory: 100)
# @sticky_note = @mike.items.create(name: 'Yellow Sticky Note', description: 'You can write on paper with it!', price: 4, image: 'https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg', inventory: 100)
# @paper_clip = @mike.items.create(name: 'Yellow Paper Clip', description: 'You can write on paper with it!', price: 6, image: 'https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg', inventory: 100)
# @push_pin = @mike.items.create(name: 'Yellow Push Pin', description: 'You can write on paper with it!', price: 6, image: 'https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg', inventory: 100)
# @stapler = @mike.items.create(name: 'Yellow Stapler', description: 'You can write on paper with it!', price: 10, image: 'https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg', inventory: 100)
# @staples = @mike.items.create(name: 'Yellow Staples', description: 'You can write on paper with it!', price: 5, image: 'https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg', inventory: 100)

# @order2 = @user.orders.create!(name: 'order', address: '123 Main St', city: 'Here', state: 'CO', zip: '58421', user_id: @user.id)
# @order2.add_item(@tire)
# @order2.add_item @paper, 7

# @order2 = @user.orders.create!(name: 'second order', address: '754 Main St', city: 'There', state: 'WY', zip: '12421', user_id: @user.id)
# @order2.add_item @paper, 4
# @order2.add_item @pencil

# @order3 = @user.orders.create!(name: 'third order', address: '754 Main St', city: 'There', state: 'WY', zip: '12421', user_id: @user.id)
# @order3.add_item @inkwell
# @order3.add_item @pen, 2
# @order3.add_item @paper, 6

# @order4 = @user.orders.create!(name: 'fourth order', address: '754 Main St', city: 'There', state: 'WY', zip: '12421', user_id: @user.id)
# @order4.add_item @stapler, 2
# @order4.add_item @staples, 10
# @order4.add_item @push_pin, 3

describe 'All merchants fulfill items on an order' do
  before :each do
    @mike = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)

    @user = User.create!(name: 'Harold Guy',
                         address: '123 Macho St',
                         city: 'Lakewood',
                         state: 'CO',
                         zip: '80328',
                         email: 'jyddedharrold@email.com',
                         password: 'luggagecombo')

    @mike_user = User.create!(name: 'Mike Guy',
                              address: '123 Macho St',
                              city: 'Lakewood',
                              state: 'CO',
                              zip: '80328',
                              email: 'mikelol@email.com',
                              password: 'luggagecombo',
                              role: 1,
                              merchant_id: @mike.id)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

    @tire = @mike.items.create(name: 'Gatorskins', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)
    @paper = @mike.items.create(name: 'Lined Paper', description: 'Great for writing on!', price: 20, image: 'https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png', inventory: 3)
    @pencil = @mike.items.create(name: 'Pencil', description: 'You can write on paper with it!', price: 2, image: 'https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg', inventory: 100)
    @pen = @mike.items.create(name: 'Yellow Pen', description: 'You can write on paper with it!', price: 2, image: 'https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg', inventory: 100)
    @inkwell = @mike.items.create(name: 'Yellow Inkwell', description: 'You can write on paper with it!', price: 4, image: 'https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg', inventory: 100)
    @lead = @mike.items.create(name: 'Yellow Lead', description: 'You can write on paper with it!', price: 1, image: 'https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg', inventory: 100)
    @sticky_note = @mike.items.create(name: 'Yellow Sticky Note', description: 'You can write on paper with it!', price: 4, image: 'https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg', inventory: 100)
    @paper_clip = @mike.items.create(name: 'Yellow Paper Clip', description: 'You can write on paper with it!', price: 6, image: 'https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg', inventory: 100)
    @push_pin = @mike.items.create(name: 'Yellow Push Pin', description: 'You can write on paper with it!', price: 6, image: 'https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg', inventory: 100)
    @stapler = @mike.items.create(name: 'Yellow Stapler', description: 'You can write on paper with it!', price: 10, image: 'https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg', inventory: 100)
    @staples = @mike.items.create(name: 'Yellow Staples', description: 'You can write on paper with it!', price: 5, image: 'https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg', inventory: 100)

    @order2 = @user.orders.create!(name: 'order', address: '123 Main St', city: 'Here', state: 'CO', zip: '58421')
    @order2.add_item(@tire)
    @order2.add_item @paper, 7

    @order2 = @user.orders.create!(name: 'second order', address: '754 Main St', city: 'There', state: 'WY', zip: '12421')
    @order2.add_item @paper, 4
    @order2.add_item @pencil

    @order3 = @user.orders.create!(name: 'third order', address: '754 Main St', city: 'There', state: 'WY', zip: '12421')
    @order3.add_item @inkwell
    @order3.add_item @pen, 2
    @order3.add_item @paper, 6

    @order4 = @user.orders.create!(name: 'fourth order', address: '754 Main St', city: 'There', state: 'WY', zip: '12421')
    @order4.add_item @stapler, 2
    @order4.add_item @staples, 10
    @order4.add_item @push_pin, 3
  end

  describe 'When all items in an order have been "fulfilled" by their merchants' do
    it 'The order status changes from "pending" to "packaged"' do
      visit profile_orders_show_path(@order4.id)
      save_and_open_page
      expect(page).to have_content('pending')
    end
  end
end

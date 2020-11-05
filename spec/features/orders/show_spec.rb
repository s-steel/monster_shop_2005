require 'rails_helper'

describe 'Order show page' do
  describe 'user control' do
    before :each do
      @user = User.create!(name: 'Harold Guy',
                           address: '123 Macho St',
                           city: 'Lakewood',
                           state: 'CO',
                           zip: '80328',
                           email: 'jyddedharrold@email.com',
                           password: 'luggagecombo')

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80_203)
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
      @tire = @meg.items.create(name: 'Gatorskins', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)
      @paper = @mike.items.create(name: 'Lined Paper', description: 'Great for writing on!', price: 20, image: 'https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png', inventory: 3)
      @pencil = @mike.items.create(name: 'Yellow Pencil', description: 'You can write on paper with it!', price: 2, image: 'https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg', inventory: 100)

      @order_1 = Order.create!(name: 'order', address: '123 Main St', city: 'Here', state: 'CO', zip: '58421', user_id: @user.id)
      @item_order_1 = @order_1.item_orders.create!(item_id: @tire.id, price: @tire.price, quantity: 2)
      @item_order_2 = @order_1.item_orders.create!(item_id: @paper.id, price: @paper.price, quantity: 3)

      @order_2 = Order.create!(name: 'second order', address: '754 Main St', city: 'There', state: 'WY', zip: '12421', user_id: @user.id)
      @item_order_3 = @order_2.item_orders.create!(item_id: @paper.id, price: @paper.price, quantity: 1)
      @item_order_4 = @order_2.item_orders.create!(item_id: @pencil.id, price: @pencil.price, quantity: 2)
    end

    it 'visit a specific order and see its info' do
      visit profile_orders_show_path(@order_1.id)
      expect(page).to have_content('Id')
      expect(page).to have_content('Date Created')
      expect(page).to have_content('Date Updated')
      expect(page).to have_content('Order Status')
      expect(page).to have_content('Item Count:')
      expect(page).to have_content('Total:')
      expect(page).to have_content(@order_1.id)
      expect(page).to have_content(@order_1.created_at.strftime('%m/%d/%Y'))
      expect(page).to have_content(@order_1.updated_at.strftime('%m/%d/%Y'))
      expect(page).to have_content(@order_1.status)
      expect(page).to have_content(@order_1.item_count)
      expect(page).to have_content("$#{@order_1.grandtotal}")

      within "#item-#{@item_order_1.item_id}" do
        expect(page).to have_content(@item_order_1.item.name)
        expect(page).to have_content(@item_order_1.item.description)
        expect(page).to have_xpath("//img[contains(@src, '#{@item_order_1.item.image}')]")
        expect(page).to have_content(@item_order_1.item.price)
        expect(page).to have_content(@item_order_1.subtotal)
        expect(page).to have_content(@item_order_1.quantity)
        expect(page).to have_content(@item_order_1.status)
      end

      within "#item-#{@item_order_2.item_id}" do
        expect(page).to have_content(@item_order_2.item.name)
        expect(page).to have_content(@item_order_2.item.description)
        expect(page).to have_xpath("//img[contains(@src, '#{@item_order_2.item.image}')]")
        expect(page).to have_content(@item_order_2.item.price)
        expect(page).to have_content(@item_order_2.subtotal)
        expect(page).to have_content(@item_order_2.quantity)
        expect(page).to have_content(@item_order_2.status)
      end
    end

    it 'I see a link to cancel the order' do
      visit profile_orders_show_path(@order_1.id)
      expect(page).to have_link('Cancel Order')
    end

    it "When I click the cancel order button, each row in the 'order items' table status is unfulfilled,
        the order is cancelled, items are returned to their merchants, I'm returned to my profile
        page and see flash saying order is cancelled and this order's status is cancelled" do
      visit profile_orders_show_path(@order_1.id)

      click_link("Cancel Order")

      expect(current_path).to eq("/profile")
      expect(page).to have_content("Your order has been cancelled.")

      visit profile_orders_show_path(@order_1.id)

      within ".order-info" do
        expect(page).to have_content('cancelled')
      end

      within "#item-#{@item_order_1.item_id}" do
        expect(page).to have_content('unfulfilled')
      end

      within "#item-#{@item_order_2.item_id}" do
        expect(page).to have_content('unfulfilled')
      end
    end

    describe 'As a merchant user' do
      before :each do
        @mike = Merchant.create(name: 'Mikemart', address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
        @meg = Merchant.create(name: 'Megmart', address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)

        @user = User.create!(name: 'Harold Guy',
                             address: '123 Macho St',
                             city: 'Lakewood',
                             state: 'CO',
                             zip: '80328',
                             email: 'jystupidd@email.com',
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

        @meg_user = User.create!(name: 'Meg Gal',
                                 address: '123 Macho St',
                                 city: 'Lakewood',
                                 state: 'CO',
                                 zip: '80328',
                                 email: 'megwoo@email.com',
                                 password: 'luggagecombo',
                                 role: 1,
                                 merchant_id: @meg.id)

        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@mike_user)

        @tire = @meg.items.create(name: 'Gatorskins', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)
        @paper = @mike.items.create(name: 'Lined Paper', description: 'Great for writing on!', price: 20, image: 'https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png', inventory: 3)
        @pencil = @mike.items.create(name: 'Pencil', description: 'You can write on paper with it!', price: 2, image: 'https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg', inventory: 100)
        @pen = @mike.items.create(name: 'Yellow Pen', description: 'You can write on paper with it!', price: 2, image: 'https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg', inventory: 100)
        @inkwell = @mike.items.create(name: 'Yellow Inkwell', description: 'You can write on paper with it!', price: 4, image: 'https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg', inventory: 100)
        @lead = @meg.items.create(name: 'Yellow Lead', description: 'You can write on paper with it!', price: 1, image: 'https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg', inventory: 100)
        @sticky_note = @mike.items.create(name: 'Yellow Sticky Note', description: 'You can write on paper with it!', price: 4, image: 'https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg', inventory: 100)
        @paper_clip = @mike.items.create(name: 'Yellow Paper Clip', description: 'You can write on paper with it!', price: 6, image: 'https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg', inventory: 100)
        @push_pin = @meg.items.create(name: 'Yellow Push Pin', description: 'You can write on paper with it!', price: 6, image: 'https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg', inventory: 100)
        @stapler = @mike.items.create(name: 'Yellow Stapler', description: 'You can write on paper with it!', price: 10, image: 'https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg', inventory: 100)
        @staples = @mike.items.create(name: 'Yellow Staples', description: 'You can write on paper with it!', price: 5, image: 'https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg', inventory: 100)

        @order2 = @user.orders.create!(name: 'order', address: '123 Main St', city: 'Here', state: 'CO', zip: '58421', user_id: @user.id)
        @order2.add_item(@tire)
        @order2.add_item @paper, 7

        @order2 = @user.orders.create!(name: 'second order', address: '754 Main St', city: 'There', state: 'WY', zip: '12421', user_id: @user.id)
        @order2.add_item @paper, 4
        @order2.add_item @pencil

        @order3 = @user.orders.create!(name: 'third order', address: '754 Main St', city: 'There', state: 'WY', zip: '12421', user_id: @user.id)
        @order3.add_item @inkwell
        @order3.add_item @pen, 2
        @order3.add_item @paper, 6

        @order4 = @user.orders.create!(name: 'fourth order', address: '754 Main St', city: 'There', state: 'WY', zip: '12421', user_id: @user.id)
        @order4.add_item @stapler, 2
        @order4.add_item @staples, 10
        @order4.add_item @push_pin, 3
      end

      it 'Visit order show page' do
        visit '/merchant'

        click_link("Order #{@order4.id}")

        expect(page).to have_content('fourth order')
        expect(page).to have_content('754 Main St')
        expect(page).to have_content('12421')
        expect(page).to have_content('There')
        expect(page).to have_content('WY')

        expect(page).to have_content(@stapler.name)
        expect(page).to have_content(@staples.name)
        expect(page).to_not have_content(@push_pin.name)

        expect(page).to have_link(@stapler.name)
        expect(page).to have_css("img[src*='#{@stapler.image}']")
        expect(page).to have_content(@stapler.price)
        expect(page).to have_content('2')

        expect(page).to have_link(@staples.name)
        expect(page).to have_css("img[src*='#{@staples.image}']")
        expect(page).to have_content(@staples.price)
        expect(page).to have_content('10')
      end
    end
  end
end

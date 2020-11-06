require 'rails_helper'

describe "As a merchant employee" do
  describe "When I visit my merchant dashboard" do
    before(:each) do
      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80_203)
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 23137)

      @merch_employee = User.create!({
        name: "Kyle",
        address: "333 Starlight Ave.",
        city: "Bakersville",
        state: "NV",
        zip: '90210',
        email: "kyle@email.com",
        password: "word",
        role: 1,
        merchant_id: @bike_shop.id
        })

      @user_1 = User.create!(name: 'Harold Guy',
                           address: '123 Macho St',
                           city: 'Lakewood',
                           state: 'CO',
                           zip: '80328',
                           email: 'jyddedharrold@email.com',
                           password: 'luggagecombo')

      @user_2 = User.create!(name: 'Adam Guy',
                           address: '333 Harvey Pkrd.',
                           city: 'Denver',
                           state: 'CO',
                           zip: '80334',
                           email: 'adam@email.com',
                           password: '12345')

      @paper = @mike.items.create(name: 'Lined Paper', description: 'Great for writing on!', price: 20, image: 'https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png', inventory: 360)
      @tire = @bike_shop.items.create(name: 'Gatorskins', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 125)
      @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 55)
      @pedal = @bike_shop.items.create(name: "Pedal", description: "Step on it", price: 10, image: "https://keyassets.timeincuk.net/inspirewp/live/wp-content/uploads/sites/11/2020/06/meow.jpg", inventory: 374)
      @reflector = @bike_shop.items.create(name: "Reflector", description: "They'll see you", price: 200, image: "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcStDVPL-iMrlZHu5mai-EXeyDH-wH2r9nBeFw&usqp=CAU", inventory: 324)

      @order_1 = Order.create!(name: 'order', address: '123 Main St', city: 'Here', state: 'CO', zip: '58421', user_id: @user_1.id, status: 'pending')
      @item_order_1 = @order_1.item_orders.create!(item_id: @tire.id, price: @tire.price, quantity: 2)
      @item_order_2 = @order_1.item_orders.create!(item_id: @paper.id, price: @paper.price, quantity: 3)
      @item_order_3 = @order_1.item_orders.create!(item_id: @chain.id, price: @chain.price, quantity: 1)

      @order_2 = Order.create!(name: 'second order', address: '754 Main St', city: 'There', state: 'WY', zip: '12421', user_id: @user_2.id, status: 'pending')
      @item_order_4 = @order_2.item_orders.create!(item_id: @pedal.id, price: @pedal.price, quantity: 4)
      @item_order_5 = @order_2.item_orders.create!(item_id: @reflector.id, price: @reflector.price, quantity: 7)
      @item_order_6 = @order_2.item_orders.create!(item_id: @paper.id, price: @paper.price, quantity: 7)

      @order_3 = Order.create!(name: 'second order', address: '754 Main St', city: 'There', state: 'WY', zip: '12421', user_id: @user_1.id, status: 'shipped')
      @item_order_7 = @order_3.item_orders.create!(item_id: @pedal.id, price: @pedal.price, quantity: 4)
      @item_order_8 = @order_3.item_orders.create!(item_id: @reflector.id, price: @reflector.price, quantity: 7)
      @item_order_9 = @order_3.item_orders.create!(item_id: @paper.id, price: @paper.price, quantity: 7)


      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merch_employee)
    end

    it "I see the name and full address of the merchant I work for" do
      visit "/merchant"

      expect(page).to have_content("Merchant Dashboard")
      expect(page).to have_content("Brian's Bike Shop")
      expect(page).to have_content("#{@bike_shop.address}")
      expect(page).to have_content("#{@bike_shop.city}")
      expect(page).to have_content("#{@bike_shop.state}")
      expect(page).to have_content("#{@bike_shop.zip}")
    end

    it "If any users have pending orders containing items I sell, I see a list of these orders" do
      visit "/merchant"

      within "#order-#{@order_1.id}" do
        expect(page).to have_content(@order_1.id)
      end
      within "#order-#{@order_2.id}" do
        expect(page).to have_content(@order_2.id)
      end

      expect(page).to_not have_content(@order_3.id)
    end

    it "I see ID of the order (linking to order show page), date order was made, total quantity of items,
        and the total value of items for that order" do
      visit "/merchant"

      expect(page).to have_content("Order Id")
      expect(page).to have_content("Date Created")
      expect(page).to have_content("Total Item Quantity")
      expect(page).to have_content("Order Total Value")

      within "#order-#{@order_1.id}" do
        expect(page).to have_link("#{@order_1.id}")
        expect(page).to have_content("#{@order_1.date_created}")
        expect(page).to have_content("3")
        expect(page).to have_content("$250.00")
      end

      within "#order-#{@order_2.id}" do
        expect(page).to have_link("#{@order_2.id}")
        expect(page).to have_content("#{@order_2.date_created}")
        expect(page).to have_content("11")
        expect(page).to have_content("$1,440.00")
      end
    end

    it "Clicking the ID of an order takes me to the order show page" do
      visit "/merchant"

      click_link "#{@order_1.id}"
      expect(current_path).to eq("/merchant/orders/#{@order_1.id}")
    end

    it 'see a link to view my own items' do
      visit "/merchant"

      expect(page).to have_link('View Your Items')
    end

    it 'click the link and I am sent to /merchant/items' do
      visit "/merchant"

      click_link "View Your Items"
      expect(current_path).to eq("/merchant/items")
    end

  end
end

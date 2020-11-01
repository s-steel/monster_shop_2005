require 'rails_helper'

describe "As an admin user" do
  describe "When I visit my admin dashboard" do
    before :each do
      @user_1 = User.create!(name: 'Neil Armstrong',
                           address: '321 Rocketman Ave.',
                           city: 'Roswell',
                           state: 'NM',
                           zip: '81234',
                           email: 'aliens@email.com',
                           password: 'area51')

      @user_2 = User.create!(name: 'Harold Guy',
                           address: '123 Macho St',
                           city: 'Lakewood',
                           state: 'CO',
                           zip: '80328',
                           email: 'jyddedharrold@email.com',
                           password: 'luggagecombo')

      @user_3 = User.create!(name: 'Lance Armstrong',
                           address: '333 Bikeshop Ln.',
                           city: 'Los Angeles',
                           state: 'CA',
                           zip: '90210',
                           email: 'bikes@email.com',
                           password: 'livestrong')

      @user_4 = User.create!(name: 'Bart Simpson',
                           address: '1431 Evergreen Terrace',
                           city: 'Springfield',
                           state: 'VT',
                           zip: '84739',
                           email: 'seymourbutts@email.com',
                           password: 'elbarto')

      @admin = User.create!({
        name: "Bruce Wayne",
        address: "456 Batcave Alley",
        city: "Gotham",
        state: "NY",
        zip: '77568',
        email: "batguy@email.com",
        password: "twoface",
        role: 2
        })

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)

      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80_203)
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)

      @tire = @meg.items.create(name: 'Gatorskins', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)
      @chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
      @pedal = @meg.items.create(name: "Pedal", description: "Step on it", price: 10, image: "https://keyassets.timeincuk.net/inspirewp/live/wp-content/uploads/sites/11/2020/06/meow.jpg", inventory: 374)
      @reflector = @meg.items.create(name: "Reflector", description: "They'll see you", price: 200, image: "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcStDVPL-iMrlZHu5mai-EXeyDH-wH2r9nBeFw&usqp=CAU", inventory: 324)
      @paper = @mike.items.create(name: 'Lined Paper', description: 'Great for writing on!', price: 20, image: 'https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png', inventory: 3)
      @pencil = @mike.items.create(name: 'Yellow Pencil', description: 'You can write on paper with it!', price: 2, image: 'https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg', inventory: 100)

      @order_1 = Order.create!(name: 'order', address: '123 Main St', city: 'Here', state: 'CO', zip: '58421', user_id: @user_1.id, status: 'pending')
      @item_order_1 = @order_1.item_orders.create!(item_id: @tire.id, price: @tire.price, quantity: 2)
      @item_order_2 = @order_1.item_orders.create!(item_id: @paper.id, price: @paper.price, quantity: 3)

      @order_2 = Order.create!(name: 'second order', address: '754 Main St', city: 'There', state: 'WY', zip: '12421', user_id: @user_2.id, status: 'shipped')
      @item_order_3 = @order_2.item_orders.create!(item_id: @paper.id, price: @paper.price, quantity: 1)
      @item_order_4 = @order_2.item_orders.create!(item_id: @pencil.id, price: @pencil.price, quantity: 2)

      @order_3 = Order.create!(name: 'Lanceman', address: '333 Bikeshop Ln.', city: 'Los Angeles', state: 'CA', zip: '90210', user_id: @user_3.id, status: 'packaged')
      @item_order_5 = @order_3.item_orders.create!(item_id: @pedal.id, price: @pedal.price, quantity: 2)
      @item_order_6 = @order_3.item_orders.create!(item_id: @reflector.id, price: @reflector.price, quantity: 1)
      @item_order_7 = @order_3.item_orders.create!(item_id: @chain.id, price: @chain.price, quantity: 1)

      @order_4 = Order.create!(name: 'El Barto', address: '1431 Evergreen Terrace', city: 'Springfield', state: 'VT', zip: '84739', user_id: @user_4.id, status: 'cancelled')
      @item_order_8 = @order_4.item_orders.create!(item_id: @reflector.id, price: @reflector.price, quantity: 300)
      @item_order_9 = @order_4.item_orders.create!(item_id: @chain.id, price: @chain.price, quantity: 1)
    end

    it "I see all orders in the system with the user who placed the order (as links), order id, and date created" do
      visit "/admin"

      within "#order-#{@order_1.id}" do
        expect(page).to have_content("#{@user_1.name}")
        expect(page).to have_content("#{@order_1.id}")
        expect(page).to have_content(@order_1.created_at.strftime('%m/%d/%Y'))
      end

      within "#order-#{@order_2.id}" do
        expect(page).to have_content("#{@user_2.name}")
        expect(page).to have_content("#{@order_2.id}")
        expect(page).to have_content(@order_2.created_at.strftime('%m/%d/%Y'))
      end

      within "#order-#{@order_3.id}" do
        expect(page).to have_content("#{@user_3.name}")
        expect(page).to have_content("#{@order_3.id}")
        expect(page).to have_content(@order_3.created_at.strftime('%m/%d/%Y'))
      end

      within "#order-#{@order_4.id}" do
        expect(page).to have_content("#{@user_4.name}")
        expect(page).to have_content("#{@order_4.id}")
        expect(page).to have_content(@order_4.created_at.strftime('%m/%d/%Y'))
      end
    end

    it "clicking order user's name takes me to admin's user show page" do
      visit "/admin"
      click_link("#{@order_1.user.name}")
      expect(current_path).to eq("/admin/users/#{@user_1.id}")
    end

    it "Orders are sorted by status: packaged, pending, shipped, cancelled" do
      visit "/admin"

      within(:xpath, "//table/tr[1]/td") do
        page.should have_content("#{@user_3.name}")
      end

      within(:xpath, "//table/tr[2]/td") do
        page.should have_content("#{@user_1.name}")
      end

      within(:xpath, "//table/tr[3]/td") do
        page.should have_content("#{@user_2.name}")
      end

      within(:xpath, "//table/tr[4]/td") do
        page.should have_content("#{@user_4.name}")
      end
    end
  end
end
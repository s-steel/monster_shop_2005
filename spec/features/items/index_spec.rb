require 'rails_helper'

RSpec.describe "Items Index Page" do
  describe "When I visit the items index page" do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 112)
      @handlebars = @meg.items.create(name: "Handle Bars", description: "Grip it", price: 50, image: "https://cdn.shopify.com/s/files/1/2191/9809/products/bullhorn2__95733.1479507031.1280.960_1024x1024.jpg?v=1501527872", inventory: 243)
      @chain = @meg.items.create(name: "Chain", description: "Strong", price: 25, image: "https://dks.scene7.com/is/image/GolfGalaxy/19SCWUBMX12X18CHRTAM?qlt=70&wid=600&fmt=pjpeg", inventory: 232)
      @pedal = @meg.items.create(name: "Pedal", description: "Step on it", price: 10, image: "https://keyassets.timeincuk.net/inspirewp/live/wp-content/uploads/sites/11/2020/06/meow.jpg", inventory: 374)
      @reflector = @meg.items.create(name: "Reflector", description: "They'll see you", price: 200, image: "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcStDVPL-iMrlZHu5mai-EXeyDH-wH2r9nBeFw&usqp=CAU", inventory: 324)
      @seat = @meg.items.create(name: "Seat", description: "Soft", price: 123, image: "https://i5.walmartimages.com/asr/597375a9-fb8f-4a47-a4a2-28201888754a_1.3ebe254d3fea4ff52d5578eda9e44f77.jpeg", inventory: 217)

      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 332)
      @dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 421)
      @kong = @brian.items.create(name: "Kong", description: "Great", price: 11, image: "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcS2YQS3IP7e4mtm-0y_erFD2slut1LxzZsPPA&usqp=CAU", inventory: 443)
      @rope = @brian.items.create(name: "Rope", description: "Strong", price: 5, image: "https://bendpetexpress.com/wp-content/uploads/2016/08/dog_toys_mammoth_rope_2knot.jpg ", inventory: 225)
      @squeeky = @brian.items.create(name: "Squeeky Toy", description: "Pretty Good", price: 12, image: "https://img.chewy.com/is/image/catalog/174770_Main._AC_SL400_V1572616735_.jpg", inventory: 274)
      @user = User.create!(name: 'Harold Guy',
                          address: '123 Macho St',
                          city: 'Lakewood',
                          state: 'CO',
                          zip: '80328',
                          email: 'shrold@email.com',
                          password: 'luggagecombo')
      @order = Order.create!(name: 'order', address: '123 Main St', city: 'Here', state: 'CO', zip: '58421', user_id: @user.id)
      @item_order_1 = @order.item_orders.create!(item_id: @tire.id, price: @tire.price, quantity: 100)
      @item_order_2 = @order.item_orders.create!(item_id: @handlebars.id, price: @handlebars.price, quantity: 200)
      @item_order_3 = @order.item_orders.create!(item_id: @chain.id, price: @chain.price, quantity: 150)
      @item_order_4 = @order.item_orders.create!(item_id: @pedal.id, price: @pedal.price, quantity: 75)
      @item_order_5 = @order.item_orders.create!(item_id: @reflector.id, price: @reflector.price, quantity: 90)
      @item_order_6 = @order.item_orders.create!(item_id: @seat.id, price: @seat.price, quantity: 120)
      @item_order_7 = @order.item_orders.create!(item_id: @pull_toy.id, price: @pull_toy.price, quantity: 80)
      @item_order_8 = @order.item_orders.create!(item_id: @kong.id, price: @kong.price, quantity: 110)
      @item_order_9 = @order.item_orders.create!(item_id: @rope.id, price: @rope.price, quantity: 70)
      @item_order_10 = @order.item_orders.create!(item_id: @squeeky.id, price: @squeeky.price, quantity: 60)
    end

    it "all items or merchant names are links" do
      visit '/items'

      expect(page).to have_link(@tire.name)
      expect(page).to have_link(@tire.merchant.name)
      expect(page).to have_link(@pull_toy.name)
      expect(page).to have_link(@pull_toy.merchant.name)
      expect(page).to_not have_link(@dog_bone.name)
      expect(page).to have_link(@dog_bone.merchant.name)
    end

    it "I can see a list of all of the items "do

      visit '/items'

      within "#item-#{@tire.id}" do
        expect(page).to have_link(@tire.name)
        expect(page).to have_content(@tire.description)
        expect(page).to have_content("Price: $#{@tire.price}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@tire.inventory}")
        expect(page).to have_link(@meg.name)
        expect(page).to have_css("img[src*='#{@tire.image}']")
      end

      within "#item-#{@pull_toy.id}" do
        expect(page).to have_link(@pull_toy.name)
        expect(page).to have_content(@pull_toy.description)
        expect(page).to have_content("Price: $#{@pull_toy.price}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@pull_toy.inventory}")
        expect(page).to have_link(@brian.name)
        expect(page).to have_css("img[src*='#{@pull_toy.image}']")
      end

      expect(page).to_not have_link(@dog_bone.name)
      expect(page).to_not have_content(@dog_bone.description)
      expect(page).to_not have_content("Price: $#{@dog_bone.price}")
      expect(page).to_not have_content("Inactive")
      expect(page).to_not have_content("Inventory: #{@dog_bone.inventory}")
      expect(page).to_not have_css("img[src*='#{@dog_bone.image}']")
    end

    it "all item images link to it's show page" do
      visit '/items'

      expect(page).to have_xpath("//img[contains(@src, '#{@tire.image}')]")
      expect(page).to have_xpath("//img[contains(@src, '#{@pull_toy.image}')]")

      find(class: "image-link-#{@tire.id}").click
      expect(current_path).to eq("/items/#{@tire.id}")

      visit '/items'
      find(class: "image-link-#{@pull_toy.id}").click
      expect(current_path).to eq("/items/#{@pull_toy.id}")
    end

    it 'see statistics for top five and bottom five items by quantity purchased plus quantity bought' do
      visit '/items'

      within '.stats-most-popular' do
        expect(page).to have_content("Top Five Most Popular Items")
        expect(page).to have_content(@handlebars.name)
        expect(page).to have_content(@chain.name)
        expect(page).to have_content(@seat.name)
        expect(page).to have_content(@kong.name)
        expect(page).to have_content(@tire.name)
        expect(page).to have_content(@item_order_2.quantity)
        expect(page).to have_content(@item_order_3.quantity)
        expect(page).to have_content(@item_order_6.quantity)
        expect(page).to have_content(@item_order_8.quantity)
        expect(page).to have_content(@item_order_1.quantity)
      end

      within '.stats-least-popular' do
        expect(page).to have_content("Top Five Least Popular Items")
        expect(page).to have_content(@squeeky.name)
        expect(page).to have_content(@rope.name)
        expect(page).to have_content(@pedal.name)
        expect(page).to have_content(@pull_toy.name)
        expect(page).to have_content(@reflector.name)
        expect(page).to have_content(@item_order_7.quantity)
        expect(page).to have_content(@item_order_5.quantity)
        expect(page).to have_content(@item_order_4.quantity)
        expect(page).to have_content(@item_order_10.quantity)
        expect(page).to have_content(@item_order_9.quantity)
      end
    end
  end
end

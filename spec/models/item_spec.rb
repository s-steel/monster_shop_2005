require 'rails_helper'

describe Item, type: :model do
  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :price }
    it { should validate_presence_of :image }
    it { should validate_presence_of :inventory }
    it { should validate_inclusion_of(:active?).in_array([true, false]) }
  end

  describe 'relationships' do
    it { should belong_to :merchant }
    it { should have_many :reviews }
    it { should have_many :item_orders }
    it { should have_many(:orders).through(:item_orders) }
  end

  describe 'instance methods' do
    before(:each) do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
      @chain = @bike_shop.items.create(name: 'Chain', description: "It'll never break!", price: 50, image: 'https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588', inventory: 5)

      @review_1 = @chain.reviews.create(title: 'Great place!', content: "They have great bike stuff and I'd recommend them to anyone.", rating: 5)
      @review_2 = @chain.reviews.create(title: 'Cool shop!', content: "They have cool bike stuff and I'd recommend them to anyone.", rating: 4)
      @review_3 = @chain.reviews.create(title: 'Meh place', content: "They have meh bike stuff and I probably won't come back", rating: 1)
      @review_4 = @chain.reviews.create(title: 'Not too impressed', content: 'v basic bike shop', rating: 2)
      @review_5 = @chain.reviews.create(title: 'Okay place :/', content: "Brian's cool and all but just an okay selection of items", rating: 3)

      @user = User.create!(name: 'Mike Dao',
                           address: '123 Main St',
                           city: 'Denver',
                           state: 'CO',
                           zip: '80428',
                           email: 'mike4@turing.com',
                           password: 'ilikefood',
                           role: 0)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end

    it 'calculate average review' do
      expect(@chain.average_review).to eq(3.0)
    end

    it 'sorts reviews' do
      top_three = @chain.sorted_reviews(3, :desc)
      bottom_three = @chain.sorted_reviews(3, :asc)

      expect(top_three).to eq([@review_1, @review_2, @review_5])
      expect(bottom_three).to eq([@review_3, @review_4, @review_5])
    end

    it 'no orders' do
      expect(@chain.no_orders?).to eq(true)
      order = @user.orders.create(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17_033)
      order.item_orders.create(item: @chain, price: @chain.price, quantity: 2)
      expect(@chain.no_orders?).to eq(false)
    end

    it 'toggle_active' do
      expect(@chain.active?).to eq(true)
      @chain.toggle_active
      expect(@chain.active?).to eq(false)
    end
  end

  describe 'class methods' do
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

    it '.best_item_stats' do
      top_three = @order.items.best_item_stats(3)

      expect(top_three).to eq([@handlebars, @chain, @seat])
    end

    it '.worst_item_stats' do
      bottom_three = @order.items.worst_item_stats(3)

      expect(bottom_three).to eq([@squeeky, @rope, @pedal])
    end
  end
end

require 'rails_helper'

describe ItemOrder, type: :model do
  describe 'validations' do
    it { should validate_presence_of :order_id }
    it { should validate_presence_of :item_id }
    it { should validate_presence_of :price }
    it { should validate_presence_of :quantity }
  end

  describe 'relationships' do
    it { should belong_to :item }
    it { should belong_to :order }
  end

  describe 'instance methods' do
    before :each do
      @user = User.create!(name: 'Mike Dao',
                           address: '123 Main St',
                           city: 'Denver',
                           state: 'CO',
                           zip: '80428',
                           email: 'mike4@turing.com',
                           password: 'ilikefood',
                           role: 0)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
      @tire = @meg.items.create(name: 'Gatorskins', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)
      @order_1 = @user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17_033)
      @item_order_1 = @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
    end

    it '#subtotal' do
      expect(@item_order_1.subtotal).to eq(200)
    end

    it '#fulfill' do
      expect(@item_order_1.status).to eq('pending')

      @item_order_1.fulfill

      expect(@item_order_1.status).to eq('fulfilled')

      expect(@order_1.status).to eq('packaged')
    end

    it '#unfulfill' do
      @item_order_1.fulfill

      expect(@item_order_1.status).to eq('fulfilled')

      @item_order_1.unfulfill

      expect(@item_order_1.status).to eq('unfulfilled')

      expect(@order_1.status).to eq('pending')
    end
  end
end

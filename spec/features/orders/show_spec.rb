require 'rails_helper'

describe 'Order show page' do
  describe 'user control' do
    before :each do
      @user = User.create!(name: 'Harold Guy',
                          address: '123 Macho St',
                          city: 'Lakewood',
                          state: 'CO',
                          zip: '80328',
                          email: 'shreddedharrold@email.com',
                          password: 'luggagecombo')

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@tire.id}"
      click_on "Add To Cart"
      visit "/items/#{@pencil.id}"
      click_on "Add To Cart"

      visit "/cart"
      click_on "Checkout"
      name = "Bert"
      address = "123 Sesame St."
      city = "NYC"
      state = "New York"
      zip = 10001

      fill_in :name, with: name
      fill_in :address, with: address
      fill_in :city, with: city
      fill_in :state, with: state
      fill_in :zip, with: zip
      click_button "Create Order"

      @order = Order.last
    end

    it 'user profile displays link' do
      visit '/profile'
      expect(page).to have_link('My Orders')
      click_link('My Orders')
      expect(current_path).to eq('/profile/orders')
    end

    it 'visit /profile/orders and see every order the user has made' do
      visit '/profile/orders'
      expect(page).to have_content('Your Orders:')
      expect(page).to have_content('Order ID:')
      expect(page).to have_content('Date order was made:')
      expect(page).to have_content('Date order was last updated:')
      expect(page).to have_content('Order Status:')
      expect(page).to have_content('Quantity of items in order:')
      expect(page).to have_content('Grand total:')
      expect(page).to have_content(@order.id)
      expect(page).to have_content(@order.created_at)
      expect(page).to have_content(@order.updated_at)
      expect(page).to have_content(@order.status)
      expect(page).to have_content(@order.items.count)
      expect(page).to have_content(@order.grandtotal)
    end
  end
end

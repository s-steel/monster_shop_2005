require 'rails_helper'

describe 'merchant index page', type: :feature do
  describe 'As a merchant employee' do
    before :each do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 80203)
      @tire = @bike_shop.items.create(name: 'Gatorskins', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 125)
      @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 55)
      @pedal = @bike_shop.items.create(name: "Pedal", description: "Step on it", price: 10, image: "https://keyassets.timeincuk.net/inspirewp/live/wp-content/uploads/sites/11/2020/06/meow.jpg", inventory: 374)
      @reflector = @bike_shop.items.create(name: "Reflector", description: "They'll see you", price: 200, image: "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcStDVPL-iMrlZHu5mai-EXeyDH-wH2r9nBeFw&usqp=CAU", inventory: 324)

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

        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merch_employee)
    end

    it 'see all my items with info: name, descrition, price, image, active? status, inventory' do
      visit '/merchant/items'

      within "#item-#{@tire.id}" do
        expect(page).to have_content(@tire.name)
        expect(page).to have_content(@tire.description)
        expect(page).to have_content(@tire.price)
        expect(page).to have_css("img[src*='#{@tire.image}']")
        expect(page).to have_content("Active")
        expect(page).to have_content(@tire.inventory)
      end
      within "#item-#{@chain.id}" do
        expect(page).to have_content(@chain.name)
        expect(page).to have_content(@chain.description)
        expect(page).to have_content(@chain.price)
        expect(page).to have_css("img[src*='#{@chain.image}']")
        expect(page).to have_content("Active")
        expect(page).to have_content(@chain.inventory)
      end
      within "#item-#{@pedal.id}" do
        expect(page).to have_content(@pedal.name)
        expect(page).to have_content(@pedal.description)
        expect(page).to have_content(@pedal.price)
        expect(page).to have_css("img[src*='#{@pedal.image}']")
        expect(page).to have_content("Active")
        expect(page).to have_content(@pedal.inventory)
      end
      within "#item-#{@reflector.id}" do
        expect(page).to have_content(@reflector.name)
        expect(page).to have_content(@reflector.description)
        expect(page).to have_content(@reflector.price)
        expect(page).to have_css("img[src*='#{@reflector.image}']")
        expect(page).to have_content("Active")
        expect(page).to have_content(@reflector.inventory)
      end
    end

    it 'see a link of button to deactivate item if it is active' do
    end

    it 'click deactivate button, returned to items index page, see flash message and item is now inactive' do
    end

    it 'I see a button or link to delete the item next to each item that has never been ordered' do
      visit "merchant/items"

      user = User.create!(name: 'Meg',
                           address: '123 Stang Ave',
                           city: 'Hershey',
                           state: 'PA',
                           zip: 17_033,
                           email: 'meg4@turing.com',
                           password: 'chocolate',
                           role: 0)

      order = user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17_033)
      order.add_item(@pedal)
      order.item_orders[0].fulfill
      order.update(status: 2)

      within "#item-#{@tire}" do
        expect(page).to have_link("Delete")
      end

      within "#item-#{@pedal.id}" do
        expect(page).to_not have_link("Delete")
      end
    end

    it "When I click the delete link for an item I am returned to the items page, no longer see that
        item, and see a flash message indicating this item is now deleted" do
      visit "merchant/items"

      within "#item-#{@tire.id}" do
        click_link("Delete")

        expect(current_path).to eq("/merchant/items")
        expect(page).to_not have_content(@tire.name)
        expect(page).to_not have_content(@tire.description)
        expect(page).to_not have_content(@tire.price)
        expect(page).to_not have_css("img[src*='#{@tire.image}']")
        expect(page).to_not have_content(@tire.status)
        expect(page).to_not have_content(@tire.inventory)

        expect(page).to have_content("Item successfully deleted.")
      end
    end

    it "When I click on the link to add a new item, I am taken to the new item form page" do
      visit "merchant/items"

      expect(page).to have_link("Add New Item")
      click_link("Add New Item")
      expect(current_path).to eq("/merchant/items/new")
    end
  end
end

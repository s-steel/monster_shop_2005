require 'rails_helper'

RSpec.describe 'merchant index page', type: :feature do
  describe 'As a user' do
    before :each do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 80203)
      @dog_shop = Merchant.create(name: "Meg's Dog Shop", address: '123 Dog Rd.', city: 'Hershey', state: 'PA', zip: 80203)
    end

    it 'I can see a list of merchants in the system' do
      visit '/merchants'

      expect(page).to have_link("Brian's Bike Shop")
      expect(page).to have_link("Meg's Dog Shop")
    end

    it 'I can see a link to create a new merchant' do
      visit '/merchants'

      expect(page).to have_link("New Merchant")

      click_on "New Merchant"

      expect(current_path).to eq("/merchants/new")
    end

    it 'as admin, can click a merchants name and will route to admin/merchants/6' do
      admin = User.create!({
        name: "Bruce Wayne",
        address: "456 Batcave Alley",
        city: "Gotham",
        state: "NY",
        zip: '77568',
        email: "batguy@email.com",
        password: "twoface",
        role: 2
        })

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

      visit '/merchants'

      click_link("#{@bike_shop.name}")
      expect(current_path).to eq("/admin/merchants/#{@bike_shop.id}")

      expect(page).to have_content(@bike_shop.name)
      expect(page).to have_content(@bike_shop.address)
      expect(page).to have_content(@bike_shop.city)
      expect(page).to have_content(@bike_shop.state)
      expect(page).to have_content(@bike_shop.zip)
      expect(page).to have_content(@bike_shop.item_count)
      expect(page).to have_link('View Your Items')
    end
  end
end

require 'rails_helper'

describe 'admin/merchant index page', type: :feature do
  describe 'As an admin' do
    before :each do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 80203)
      @dog_shop = Merchant.create(name: "Meg's Dog Shop", address: '123 Dog Rd.', city: 'Hershey', state: 'PA', zip: 80203)

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

    end

    it 'visit merchant index page and see diable button mext to merchants' do
      visit '/admin/merchants'

      within "#merchant-#{@bike_shop.id}" do
        expect(page).to have_button('Disable')
      end

      within "#merchant-#{@dog_shop.id}" do
        expect(page).to_not have_button('Disable')
      end
    end

    it 'click diable and returned to admin merchants index page where I see merchant diabled, and see flash message'


  end
end

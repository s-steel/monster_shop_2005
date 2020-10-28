require 'rails_helper'

describe "As a registered user, merchant, or admin" do
  describe "When I visit the logout path" do
    it "I am redirected to the home page of the site and I
        see a flash message that indicates I am logged out" do
      user = User.create!(name: 'Mike Dao',
                          address: '123 Main St',
                          city: 'Denver',
                          state: 'CO',
                          zip: '80428',
                          email: 'mike3@turing.com',
                          password: 'ilikefood')

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

      visit "/items/#{tire.id}"
      click_button "Add To Cart"
      expect(page).to have_content("Cart: 1")

      click_link "Logout"
      expect(current_path).to eq('/')
      expect(page).to have_content('You are logged out!')
      expect(page).to have_content('Cart: 0')
    end
  end
end
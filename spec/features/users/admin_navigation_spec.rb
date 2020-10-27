require 'rails_helper'

describe "As an admin" do
  describe "I see the same links as a regular user" do
    it "plus a link to admin dashboard and to see all users
        minus a link to shopping cart" do
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

      visit '/'

      within '.topnav' do
        expect(page).to have_link('Profile')
        expect(page).to have_link('Logout')
        expect(page).to have_link('Home')
        expect(page).to have_link('All Merchants')
        expect(page).to have_link('All Items')
        expect(page).to have_link('Admin Dashboard')
        expect(page).to have_link('All Users')

        expect(page).to_not have_link('Cart: 0')
        expect(page).to_not have_link('Login')
        expect(page).to_not have_link('Register')
      end

      expect(page).to have_content("Logged in as #{admin.name}")
    end
  end
end

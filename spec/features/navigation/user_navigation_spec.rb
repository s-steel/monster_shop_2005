
require 'rails_helper'

describe 'User navigation bar' do
  describe 'As a default user' do
    it "I see a nav bar with links to certain pages" do
      user = User.create!(name: 'Mike Dao',
                          address: '123 Main St',
                          city: 'Denver',
                          state: 'CO',
                          zip: 80428,
                          email: 'asdfa@turing.com',
                          password: 'ilikefood')

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit '/'

      within '.topnav' do
        expect(page).to have_link('Profile')
        expect(page).to have_link('Logout')
        expect(page).to have_link('Home')
        expect(page).to have_link('All Merchants')
        expect(page).to have_link('All Items')
        expect(page).to_not have_link('Login')
        expect(page).to_not have_link('Register')
      end

      expect(page).to have_content("Logged in as #{user.name}")
    end

    describe 'User navigation restrictions' do
      before :each do
        user = User.create!(name: 'Mike Dao',
          address: '123 Main St',
          city: 'Denver',
          state: 'CO',
          zip: 80428,
          email: 'madthg@turing.com',
          password: 'ilikefood')

          allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      end

      it 'user cannot see /merchant' do

        visit "/merchant"

        expect(page).to have_content("The page you were looking for doesn't exist.")
      end

      it 'user cannot see /admin' do
        visit "/admin"

        expect(page).to have_content("The page you were looking for doesn't exist.")
      end
    end
  end
end

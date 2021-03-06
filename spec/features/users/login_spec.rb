require 'rails_helper'

describe "As a visitor" do
  describe "When I visit the login path" do
    it "I see a field to enter my email and password" do
      visit '/login'

      expect(page).to have_content('Login')
      expect(page).to have_field('Email')
      expect(page).to have_field('Password')
      expect(page).to have_button('Login')
    end

    describe "When I submit valid information" do
      it "If I am a regular user, I am redirected to my profile page" do
        user = User.create!(name: 'Mike Dao',
                            address: '123 Main St',
                            city: 'Denver',
                            state: 'CO',
                            zip: '80428',
                            email: 'mike1@turing.com',
                            password: 'ilikefood')

        visit '/login'

        fill_in 'Email', with: "#{user.email}"
        fill_in 'Password', with: "#{user.password}"
        click_button 'Login'

        expect(current_path).to eq("/profile")
        expect(page).to have_content("Login Successful!")
      end

      it "If I am a merchant user, I am redirected to my merchant dashboard" do
        bike_shop = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80_203)

        merch_employee = User.create!({
          name: "Kyle",
          address: "333 Starlight Ave.",
          city: "Bakersville",
          state: "NV",
          zip: '90210',
          email: "kyle@email.com",
          password: "word",
          role: 1,
          merchant_id: bike_shop.id
          })

        visit '/login'

        fill_in 'Email', with: "#{merch_employee.email}"
        fill_in 'Password', with: "#{merch_employee.password}"
        click_button 'Login'

        expect(current_path).to eq("/merchant")
        expect(page).to have_content("Login Successful!")
      end

      it "If I am an admin user, I am redirected to my admin dashboard" do
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

        visit '/login'

        fill_in 'Email', with: "#{admin.email}"
        fill_in 'Password', with: "#{admin.password}"
        click_button 'Login'

        expect(current_path).to eq("/admin")
        expect(page).to have_content("Login Successful!")
      end
    end

    describe "I enter invalid information" do
      it do
        user = User.create!(name: 'Mike Dao',
                            address: '123 Main St',
                            city: 'Denver',
                            state: 'CO',
                            zip: '80428',
                            email: 'mike2@turing.com',
                            password: 'ilikefood')

        visit '/login'
        fill_in 'Email', with: "#{user.email}"
        fill_in 'Password', with: "ihatefood"
        click_button 'Login'
        expect(page).to have_content('Invalid email or password, please try again.')

        visit '/login'
        fill_in 'Email', with: "billy@nowhere.org"
        fill_in 'Password', with: "#{user.password}"
        click_button 'Login'
        expect(page).to have_content('Invalid email or password, please try again.')
      end
    end

    describe 'I am already logged in' do
      before :each do
        @user = User.create!(name: 'Mike Dao',
                             address: '123 Main St',
                             city: 'Denver',
                             state: 'CO',
                             zip: '80428',
                             email: 'usermike@turing.com',
                             password: 'ilikefood',
                             role: 0)

        @admin = User.create!(name: 'Mike Dao',
                              address: '123 Main St',
                              city: 'Denver',
                              state: 'CO',
                              zip: '80428',
                              email: 'adminmike@turing.com',
                              password: 'ilikefood',
                              role: 2)

        @print_shop = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80_203)


        @merchant = User.create!(name: 'Mike Dao',
                                 address: '123 Main St',
                                 city: 'Denver',
                                 state: 'CO',
                                 zip: '80428',
                                 email: 'mike5@turing.com',
                                 password: 'ilikefood',
                                 role: 1,
                                 merchant_id: @print_shop.id)
      end

      it 'as a user' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

        visit '/login'

        expect(page).to have_current_path '/profile'
        expect(page).to have_content('You are already logged in!')
      end

      it 'as a merchant' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

        visit '/login'

        expect(page).to have_current_path '/merchant'
        expect(page).to have_content('You are already logged in!')
      end

      it 'as an admin' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)

        visit '/login'

        expect(page).to have_current_path '/admin'
        expect(page).to have_content('You are already logged in!')
      end
    end
  end
end

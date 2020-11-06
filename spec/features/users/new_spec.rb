require 'rails_helper'

describe 'new registration' do
  describe 'create new user' do
    before :each do
      visit '/register'
    end

    it 'fill in form with name, address, city, state, address, password, confirm password' do
      expect(page).to have_field('user[name]', type: 'text')
      expect(page).to have_field('user[address]', type: 'text')
      expect(page).to have_field('user[city]', type: 'text')
      expect(page).to have_field('user[state]', type: 'text')
      expect(page).to have_field('user[zip]', type: 'text')
      expect(page).to have_field('user[email]', type: 'text')
      expect(page).to have_field('user[password]', type: 'text')
      expect(page).to have_field('user[confirm_password]', type: 'text')

      fill_in 'user[name]', with: 'Bobby'
      fill_in 'user[address]', with: '123 Main St'
      fill_in 'user[city]', with: 'Denver'
      fill_in 'user[state]', with: 'CO'
      fill_in 'user[zip]', with: '12345'
      fill_in 'user[email]', with: 'bob@email.com'
      fill_in 'user[password]', with: 'password'
      fill_in 'user[confirm_password]', with: 'password'

      click_button 'Submit'
      expect(current_path).to eq('/profile')
      expect(page).to have_content('You are now registered and logged in')
    end

    it 'fill in forms without all information, page does not change and flash message' do
      fill_in 'user[email]', with: 'bob@email.com'
      fill_in 'user[password]', with: 'password'
      fill_in 'user[confirm_password]', with: 'password'

      click_button 'Submit'
      expect(current_path).to eq('/register')
      expect(page).to have_content('Please enter data in all required fields')
    end

    it 'fill out forms with a reused email, page does not change and flash message' do
      User.create(name: 'Carl',
                  address: '1234 w edgar ave',
                  city: 'denver',
                  state: 'co',
                  zip: '12345',
                  email: 'bob@email.com',
                  password: 'bobsux')

      fill_in 'user[name]', with: 'Bobby'
      fill_in 'user[address]', with: '123 Main St'
      fill_in 'user[city]', with: 'Denver'
      fill_in 'user[state]', with: 'CO'
      fill_in 'user[zip]', with: '12345'
      fill_in 'user[email]', with: 'bob@email.com'
      fill_in 'user[password]', with: 'password'
      fill_in 'user[confirm_password]', with: 'password'

      click_button 'Submit'
      expect(current_path).to eq('/register')
      expect(page).to have_content('This email is already registered. Please use a new email.')
    end

    it 'if I fill in password fields without matching them I get an error' do
      fill_in 'user[name]', with: 'Bobby'
      fill_in 'user[address]', with: '123 Main St'
      fill_in 'user[city]', with: 'Denver'
      fill_in 'user[state]', with: 'CO'
      fill_in 'user[zip]', with: '12345'
      fill_in 'user[email]', with: 'bob@email.com'
      fill_in 'user[password]', with: 'password'
      fill_in 'user[confirm_password]', with: 'multipass'

      click_button 'Submit'
      expect(current_path).to eq('/register')
      expect(page).to have_content('Passwords must match.')
    end
  end
end

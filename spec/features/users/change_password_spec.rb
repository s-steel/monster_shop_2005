require 'rails_helper'

describe 'As a registered user' do
  describe 'When I visit my profile page' do
    before(:each) do
      user = User.create!(name: 'Mike Dao',
                          address: '123 Main St',
                          city: 'Denver',
                          state: 'CO',
                          zip: '80428',
                          email: 'mike3@turing.com',
                          password: 'ilikefood',
                          password_confirmation: 'ilikefood')

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    end

    it 'I see a link to edit my password' do
      visit '/profile'
      expect(page).to have_link('Change Password')
    end

    it "When I click the change password link, I see a form with fields for a new password
        and a new password confirmation" do
      visit '/profile'
      click_link 'Change Password'

      expect(current_path).to eq('/profile/change-password')
      expect(page).to have_content('Change Your Password')
      expect(page).to have_field(:password)
      expect(page).to have_field(:confirm_password)
      expect(page).to have_button('Submit')
    end

    it "When I fill the same password in both fields and submit, I am retured to my
        profile page and see flash that the password is updated" do
      visit '/profile'
      click_link 'Change Password'

      fill_in :password, with: 'multipass'
      fill_in :confirm_password, with: 'multipass'
      click_button 'Submit'

      expect(current_path).to eq('/profile')
      expect(page).to have_content('Password updated successfully!')
    end
  end
end

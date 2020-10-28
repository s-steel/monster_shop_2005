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

      click_link "Logout"
      expect(current_path).to eq('/')
      expect(page).to have_content('You are logged out!')
    end
  end
end
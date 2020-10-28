require 'rails_helper'

describe "As a registered user" do
  describe "When I visit my profile page" do
    before(:each)do
      user = User.create!(name: 'Mike Dao',
                          address: '123 Main St',
                          city: 'Denver',
                          state: 'CO',
                          zip: '80428',
                          email: 'mike3@turing.com',
                          password: 'ilikefood')

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    end

    it "I see a link to edit my password" do
      visit '/profile'
      expect(page).to have_link("Change Password")
    end
  end
end
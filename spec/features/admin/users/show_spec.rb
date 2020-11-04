require 'rails_helper'

describe "As an Admin user" do
  describe "When I visit a user's profile page" do
    before(:each) do
      @user = User.create!(name: 'Mike Dao',
        address: '123 Main St',
        city: 'Denver',
        state: 'CO',
        zip: '80428',
        email: 'mike5@turing.com',
        password: 'ilikefood',
        role: 0)

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

    it "I see the same info the user would" do
      visit "/admin/users/#{@user.id}"

      expect(page).to have_content("User Profile")
      expect(page).to have_content(@user.name)
      expect(page).to have_content(@user.address)
      expect(page).to have_content(@user.city)
      expect(page).to have_content(@user.state)
      expect(page).to have_content(@user.zip)
      expect(page).to have_content(@user.email)
      expect(page).to have_link("My Orders")

      expect(page).to_not have_link("Edit Profile")
      expect(page).to_not have_link("Change Password")
    end
  end
end
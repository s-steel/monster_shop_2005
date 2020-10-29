require 'rails_helper'

describe "As a registered user" do
  describe "When I visit my edit profile page" do
    before(:each) do
      @user = User.create!(name: 'Harold Guy',
                          address: '123 Macho St',
                          city: 'Lakewood',
                          state: 'CO',
                          zip: '80328',
                          email: 'harold@email.com',
                          password: 'luggagecombo')

      @user_2 = User.create!(name: 'Mike Dao',
                          address: '123 Main St',
                          city: 'Denver',
                          state: 'CO',
                          zip: '80428',
                          email: 'mike3@turing.com',
                          password: 'ilikefood')

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end

    it "I see a form that's prepopulated with all current information besides password.
        After changing and submitting, I am returned to my profile page and see a flash
        that info is updated" do
      visit '/profile/edit'

      expect(page).to have_content("Edit Profile")
      expect(find_field('user[name]').value).to eq("#{@user.name}")
      expect(find_field('user[address]').value).to eq("#{@user.address}")
      expect(find_field('user[city]').value).to eq("#{@user.city}")
      expect(find_field('user[state]').value).to eq("#{@user.state}")
      expect(find_field('user[zip]').value).to eq("#{@user.zip}")
      expect(find_field('user[email]').value).to eq("#{@user.email}")

      fill_in 'user[name]', with: "Harry Guy"
      click_button('Submit')

      expect(current_path).to eq('/profile')
      expect(page).to have_content("Harry Guy")
      expect(page).to have_content("Profile updated successfully!")
    end

    it "If I try to change my email address to one that belongs to an existing user,
        I am returned to the profile edit page and see flash telling me the email
        is taken" do
      visit "/profile/edit"

      fill_in 'user[email]', with: "mike3@turing.com"
      click_button('Submit')

      expect(current_path).to eq("/profile/edit")
      expect(page).to have_content("This email is already registered. Please use a new email.")
    end
  end
end

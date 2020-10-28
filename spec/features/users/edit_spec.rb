require 'rails_helper'

describe "As a registered user" do
  describe "When I visit my edit profile page" do
    it "I see a form that's prepopulated with all current information besides password.
        After changing and submitting, I am returned to my profile page and see a flash
        that info is updated" do
      visit '/profile'

      click_link "Edit Profile"
      expect(current_path).to eq("/profile/edit")

      expect(find_field(:name).value).to eq("#{@user.name}")
      expect(find_field(:address).value).to eq("#{@user.address}")
      expect(find_field(:city).value).to eq("#{@user.city}")
      expect(find_field(:state).value).to eq("#{@user.state}")
      expect(find_field(:zip).value).to eq("#{@user.zip}")
      expect(find_field(:email).value).to eq("#{@user.email}")

      fill_in :name, with: "Harry Guy"
      click_button('Submit')

      expect(current_path).to eq('/profile')
      expect(page).to have_content("Harry Guy")
    end
  end
end

require 'rails_helper'

describe "If I try to visit this path as a visitor" do
  it "I get a 404" do
    visit "/profile"

    expect(page).to have_content("The page you were looking for doesn't exist.")
  end
end

describe "As a registered user" do
  describe "When I visit my profile page" do
    before(:each) do
      @user = User.create!(name: 'Harold Guy',
                          address: '123 Macho St',
                          city: 'Lakewood',
                          state: 'CO',
                          zip: '80328',
                          email: 'harold@email.com',
                          password: 'luggagecombo')

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end

    it "I see all of my profile data on the page minus password and a link to edit" do

      visit '/profile'

      expect(page).to have_content("Profile")
      expect(page).to have_content("#{@user.name}")
      expect(page).to have_content("#{@user.address}")
      expect(page).to have_content("#{@user.city}")
      expect(page).to have_content("#{@user.state}")
      expect(page).to have_content("#{@user.zip}")
      expect(page).to have_content("#{@user.email}")

      expect(page).to have_link("Edit Profile")
    end

    it "when I click on the link to edit my profile, I see a form that's prepopulated
        with all current information besides password.  After changing and submitting,
        I am returned to my profile page and see a flash that info is updated" do
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
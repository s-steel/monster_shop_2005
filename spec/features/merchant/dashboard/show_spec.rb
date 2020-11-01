require 'rails_helper'

describe "As a merchant employee" do
  describe "When I visit my merchant dashboard" do
    before(:each) do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 23137)
      @merch_employee = User.create!({
        name: "Kyle",
        address: "333 Starlight Ave.",
        city: "Bakersville",
        state: "NV",
        zip: '90210',
        email: "kyle@email.com",
        password: "word",
        role: 1,
        merchant_id: @bike_shop.id
        })

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merch_employee)
    end
    it "I see the name and full address of the merchant I work for" do
      visit "/merchant"

      expect(page).to have_content("Merchant Dashboard")
      expect(page).to have_content("Brian's Bike Shop")
      expect(page).to have_content("#{@bike_shop.address}")
      expect(page).to have_content("#{@bike_shop.city}")
      expect(page).to have_content("#{@bike_shop.state}")
      expect(page).to have_content("#{@bike_shop.zip}")
    end
  end
end
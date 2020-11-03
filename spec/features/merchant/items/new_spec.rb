require 'rails_helper'

describe "As a merchant employee" do
  describe "When I visit the new item form page" do
    before(:each) do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 80203)
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

    it "I see a form for the following information" do
      visit "/merchant/items/new"

      expect(page).to have_field('item[name]')
      expect(page).to have_field('item[description]')
      expect(page).to have_field('item[image]')
      expect(page).to have_field('item[price]')
      expect(page).to have_field('item[inventory]')
      expect(page).to have_button('Create Item')
    end
  end
end
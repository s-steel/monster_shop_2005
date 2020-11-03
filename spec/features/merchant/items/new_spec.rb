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

    it "Name field cannot be blank" do
      visit "/merchant/items/new"

      fill_in 'item[name]', with: ""
      fill_in 'item[description]', with: "Safety First!"
      fill_in 'item[image]', with: "https://i.shgcdn.com/944e4e88-f81a-4975-b2a2-c9beb2d3bcf1/-/format/auto/-/preview/3000x3000/-/quality/lighter/"
      fill_in 'item[price]', with: "25"
      fill_in 'item[inventory]', with: "10"
      click_button('Create Item')

      expect(page).to have_content("Name cannot be blank.")
      expect(current_path).to eq("/merchant/items/new")
    end
  end
end
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

    it "Entering valid info and submitting, I'm taken to items page with a flash
      message saying my item is saved, with the item on the page and enabled for sale" do
      visit "/merchant/items/new"

      fill_in 'item[name]', with: "Helmet"
      fill_in 'item[description]', with: "Safety First!"
      fill_in 'item[image]', with: "https://i.shgcdn.com/944e4e88-f81a-4975-b2a2-c9beb2d3bcf1/-/format/auto/-/preview/3000x3000/-/quality/lighter/"
      fill_in 'item[price]', with: "25"
      fill_in 'item[inventory]', with: "15"
      click_button('Create Item')

      expect(current_path).to eq('/merchant/items')
      expect(page).to have_content('Item added successfully!')

      expect(page).to have_content('Helmet')
      expect(page).to have_css("img[src*='https://i.shgcdn.com/944e4e88-f81a-4975-b2a2-c9beb2d3bcf1/-/format/auto/-/preview/3000x3000/-/quality/lighter/']")
      expect(page).to have_content('Safety First!')
      expect(page).to have_content('Inventory: 15')
      expect(page).to have_content('Active')
    end

    it 'Image URL may be left blank' do
      visit "/merchant/items/new"

      fill_in 'item[name]', with: "Helmet"
      fill_in 'item[description]', with: "Safety First!"
      fill_in 'item[image]', with: ""
      fill_in 'item[price]', with: "25"
      fill_in 'item[inventory]', with: "10"
      click_button('Create Item')

      expect(current_path).to eq('/merchant/items')
      expect(page).to have_content('Helmet')
      expect(page).to have_content('Safety First!')
    end

    it "If image URL was blank, a placeholder image is found" do
      visit "/merchant/items/new"

      fill_in 'item[name]', with: "Helmet"
      fill_in 'item[description]', with: "Safety First!"
      fill_in 'item[image]', with: ""
      fill_in 'item[price]', with: "25"
      fill_in 'item[inventory]', with: "15"
      click_button('Create Item')

      expect(current_path).to eq('/merchant/items')
      expect(page).to have_css("img[src*='https://snellservices.com/wp-content/uploads/2019/07/image-coming-soon.jpg']")
    end

    it "Name field cannot be blank" do
      visit "/merchant/items/new"

      fill_in 'item[name]', with: ""
      fill_in 'item[description]', with: "Safety First!"
      fill_in 'item[image]', with: "https://i.shgcdn.com/944e4e88-f81a-4975-b2a2-c9beb2d3bcf1/-/format/auto/-/preview/3000x3000/-/quality/lighter/"
      fill_in 'item[price]', with: "25"
      fill_in 'item[inventory]', with: "10"
      click_button('Create Item')

      expect(page).to have_content("Name can't be blank")
      expect(page).to have_content('Enter New Item Info')
    end

    it "Description cannot be blank" do
      visit "/merchant/items/new"

      fill_in 'item[name]', with: "Helmet"
      fill_in 'item[description]', with: ""
      fill_in 'item[image]', with: "https://i.shgcdn.com/944e4e88-f81a-4975-b2a2-c9beb2d3bcf1/-/format/auto/-/preview/3000x3000/-/quality/lighter/"
      fill_in 'item[price]', with: "25"
      fill_in 'item[inventory]', with: "10"
      click_button('Create Item')

      expect(page).to have_content("Description can't be blank")
      expect(page).to have_content('Enter New Item Info')
    end

    it 'Price must be greater than $0.00' do
      visit "/merchant/items/new"

      fill_in 'item[name]', with: "Helmet"
      fill_in 'item[description]', with: "Safety First!"
      fill_in 'item[image]', with: "https://i.shgcdn.com/944e4e88-f81a-4975-b2a2-c9beb2d3bcf1/-/format/auto/-/preview/3000x3000/-/quality/lighter/"
      fill_in 'item[price]', with: "0"
      fill_in 'item[inventory]', with: "10"
      click_button('Create Item')

      expect(page).to have_content('Price must be greater than 0')
      expect(page).to have_content('Enter New Item Info')
    end

    it 'Inventory must be greater than 0' do
      visit "/merchant/items/new"

      fill_in 'item[name]', with: "Helmet"
      fill_in 'item[description]', with: "Safety First!"
      fill_in 'item[image]', with: "https://i.shgcdn.com/944e4e88-f81a-4975-b2a2-c9beb2d3bcf1/-/format/auto/-/preview/3000x3000/-/quality/lighter/"
      fill_in 'item[price]', with: "25"
      fill_in 'item[inventory]', with: "0"
      click_button('Create Item')

      expect(page).to have_content('Inventory must be greater than zero.')
      expect(page).to have_content('Enter New Item Info')
    end

    it "When incorrectly filling a form, I see fields are repopulated with previous data" do
      visit "/merchant/items/new"

      fill_in 'item[name]', with: ""
      fill_in 'item[description]', with: "Safety First!"
      fill_in 'item[image]', with: "https://i.shgcdn.com/944e4e88-f81a-4975-b2a2-c9beb2d3bcf1/-/format/auto/-/preview/3000x3000/-/quality/lighter/"
      fill_in 'item[price]', with: "25"
      fill_in 'item[inventory]', with: "10"
      click_button('Create Item')

      expect(page).to have_content("Name can't be blank")
      expect(page).to have_content('Enter New Item Info')

      expect(find_field('item[name]').value).to eq('')
      expect(find_field('item[description]').value).to eq('Safety First!')
      expect(find_field('item[image]').value).to eq("https://i.shgcdn.com/944e4e88-f81a-4975-b2a2-c9beb2d3bcf1/-/format/auto/-/preview/3000x3000/-/quality/lighter/")
      expect(find_field('item[price]').value).to eq("25")
      expect(find_field('item[inventory]').value).to eq("10")
    end
  end
end
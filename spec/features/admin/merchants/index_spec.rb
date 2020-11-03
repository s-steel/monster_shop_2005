require 'rails_helper'

describe 'admin/merchant index page', type: :feature do
  describe 'As an admin' do
    before :each do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 80203)
      @dog_shop = Merchant.create(name: "Meg's Dog Shop", address: '123 Dog Rd.', city: 'Hershey', state: 'PA', zip: 80203, active?: false)

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

      @user = User.create!(name: 'Harold Guy',
        address: '123 Macho St',
        city: 'Lakewood',
        state: 'CO',
        zip: '80328',
        email: 'harold@email.com',
        password: 'luggagecombo')

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)

      @pull_toy = @dog_shop.items.create(name: 'Pull Toy', description: 'Great pull toy!', price: 10, image: 'http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg', inventory: 32, active?: false)
      @dog_bone = @dog_shop.items.create(name: 'Dog Bone', description: "They'll love it!", price: 21, image: 'https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg', inventory: 21, active?: false)
      @tire = @bike_shop.items.create(name: 'Gatorskins', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)
      @pen = @bike_shop.items.create(name: 'Yellow Pen', description: 'You can write on paper with it!', price: 2, image: 'https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg', inventory: 100)
    end

    it 'visit merchant index page and see diable button mext to merchants' do
      visit '/admin/merchants'

      within ".merchant-#{@bike_shop.id}" do
        expect(page).to have_button('Disable')
      end

      within ".merchant-#{@dog_shop.id}" do
        expect(page).to_not have_button('Disable')
      end
    end

    it 'click diable and returned to admin merchants index page where I see merchant diabled, and see flash message' do
      visit '/admin/merchants'

      within ".merchant-#{@bike_shop.id}" do
        click_button('Disable')
      end

      expect(current_path).to eq("/admin/merchants")
      expect(page).to have_content("#{@bike_shop.name} is now disabled")

      within ".merchant-#{@bike_shop.id}" do
        expect(page).to_not have_button('Disable')
      end
    end

    it 'visit merchant index page and click disable for merchant, all their items should be deactivated' do
      visit '/admin/merchants'

      expect(@tire.active?).to eq(true)
      expect(@pen.active?).to eq(true)

      within ".merchant-#{@bike_shop.id}" do
        click_button('Disable')
      end

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
      visit '/items'

      expect(page).to_not have_content(@tire.name)
      expect(page).to_not have_content(@pen.name)
    end

    it 'see enable button next to any merchant who are disabled' do
      visit '/admin/merchants'

      within ".merchant-#{@bike_shop.id}" do
        expect(page).to have_button('Disable')
        expect(page).to_not have_button('Enable')
      end

      within ".merchant-#{@dog_shop.id}" do
        expect(page).to_not have_button('Disable')
        expect(page).to have_button('Enable')
      end
    end

    it 'click enable, returned to admin merchant index page and see account is now enabled, and see flash message saying so'


  end
end

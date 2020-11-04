require 'rails_helper'

describe 'US 50-51: Merchant order fulfillment' do
  before :each do
    @mike = Merchant.create(name: 'Mikemart', address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
    @meg = Merchant.create(name: 'Megmart', address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)

    @user = User.create!(name: 'Harold Guy',
                         address: '123 Macho St',
                         city: 'Lakewood',
                         state: 'CO',
                         zip: '80328',
                         email: 'jyddedharrold@email.com',
                         password: 'luggagecombo')

    @mike_user = User.create!(name: 'Mike Guy',
                              address: '123 Macho St',
                              city: 'Lakewood',
                              state: 'CO',
                              zip: '80328',
                              email: 'mikelol@email.com',
                              password: 'luggagecombo',
                              role: 1,
                              merchant_id: @mike.id)

    @meg_user = User.create!(name: 'Meg Gal',
                             address: '123 Macho St',
                             city: 'Lakewood',
                             state: 'CO',
                             zip: '80328',
                             email: 'megwoo@email.com',
                             password: 'luggagecombo',
                             role: 1,
                             merchant_id: @meg.id)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@mike_user)

    @tire = @meg.items.create(name: 'Gatorskins', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)
    @paper = @mike.items.create(name: 'Lined Paper', description: 'Great for writing on!', price: 20, image: 'https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png', inventory: 3)
    @pencil = @mike.items.create(name: 'Pencil', description: 'You can write on paper with it!', price: 2, image: 'https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg', inventory: 100)
    @pen = @mike.items.create(name: 'Yellow Pen', description: 'You can write on paper with it!', price: 2, image: 'https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg', inventory: 100)
    @inkwell = @mike.items.create(name: 'Yellow Inkwell', description: 'You can write on paper with it!', price: 4, image: 'https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg', inventory: 100)
    @lead = @meg.items.create(name: 'Yellow Lead', description: 'You can write on paper with it!', price: 1, image: 'https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg', inventory: 100)
    @sticky_note = @mike.items.create(name: 'Yellow Sticky Note', description: 'You can write on paper with it!', price: 4, image: 'https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg', inventory: 100)
    @paper_clip = @mike.items.create(name: 'Yellow Paper Clip', description: 'You can write on paper with it!', price: 6, image: 'https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg', inventory: 100)
    @push_pin = @meg.items.create(name: 'Yellow Push Pin', description: 'You can write on paper with it!', price: 6, image: 'https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg', inventory: 100)
    @stapler = @mike.items.create(name: 'Yellow Stapler', description: 'You can write on paper with it!', price: 10, image: 'https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg', inventory: 100)
    @staples = @mike.items.create(name: 'Yellow Staples', description: 'You can write on paper with it!', price: 5, image: 'https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg', inventory: 100)

    @order1 = @user.orders.create!(name: 'order', address: '123 Main St', city: 'Here', state: 'CO', zip: '58421', user_id: @user.id)
    @order1.add_item(@tire)
    @order1.add_item @paper, 7

    @order2 = @user.orders.create!(name: 'second order', address: '754 Main St', city: 'There', state: 'WY', zip: '12421', user_id: @user.id)
    @order2.add_item @paper, 4
    @order2.add_item @pencil

    @order3 = @user.orders.create!(name: 'third order', address: '754 Main St', city: 'There', state: 'WY', zip: '12421', user_id: @user.id)
    @order3.add_item @inkwell
    @order3.add_item @pen, 2
    @order3.add_item @paper, 6

    @order4 = @user.orders.create!(name: 'fourth order', address: '754 Main St', city: 'There', state: 'WY', zip: '12421', user_id: @user.id)
    @item_order1 = @order4.add_item @stapler, 2
    @item_order2 = @order4.add_item @staples, 10
    @item_order3 = @order4.add_item @push_pin, 3
    @item_order4 = @order4.add_item @paper, 10
  end

  it 'Part fulfillment' do
    visit merchant_path

    click_link("Order #{@order4.id}")

    within("#item_order-#{@item_order1.id}") do
      click_button('Fulfill')
    end

    expect(page).to have_current_path("/merchant/orders/#{@order4.id}")

    within("#item_order-#{@item_order1.id}") do
      expect(page).to have_content('Fulfilled')
    end

    expect(page).to have_content('Item fulfilled!')

    @stapler.reload

    expect(@stapler.inventory).to eq(98)
  end

  it 'Cannot fulfill due to lack of inventory' do
    visit merchant_path

    click_link("Order #{@order4.id}")

    within("#item_order-#{@item_order4.id}") do
      expect(page).to_not have_link('Fulfill')
      expect(page).to have_content('Cannot fulfill due to lack of inventory')
    end

  end
end

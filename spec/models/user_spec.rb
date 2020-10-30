require 'rails_helper'

describe User, type: :model do
  describe 'validations' do
    it do
      should validate_presence_of :name
      should validate_presence_of :address
      should validate_presence_of :city
      should validate_presence_of :state
      should validate_presence_of :zip
      should validate_presence_of :email
      should validate_presence_of :password

      should validate_uniqueness_of :email
    end
  end

  describe 'relationships' do
    it do
      should have_many :orders
    end
  end

  describe "roles" do
    it "can be created as a default user" do
      user = User.create!(name: 'Mike Dao',
                          address: '123 Main St',
                          city: 'Denver',
                          state: 'CO',
                          zip: '80428',
                          email: 'mike4@turing.com',
                          password: 'ilikefood',
                          role: 0)

      expect(user.role).to eq("default")
      expect(user.default?).to be_truthy
    end

    it "can be created as a merchant employee" do
      user = User.create!({
        name: "Kyle",
        address: "333 Starlight Ave.",
        city: "Bakersville",
        state: "NV",
        zip: '90210',
        email: "kyle@email.com",
        password: "word",
        role: 1
        })

      expect(user.role).to eq("merchant_employee")
      expect(user.merchant_employee?).to be_truthy
    end

    xit "can be created as an admin" do
      user = User.create!({
        name: "Bruce Wayne",
        address: "456 Batcave Alley",
        city: "Gotham",
        state: "NY",
        zip: '77568',
        email: "batguy@email.com",
        password: "twoface",
        role: 2
        })

      expect(user.role).to eq("admin")
      expect(user.admin?).to be_truthy
    end
  end
end

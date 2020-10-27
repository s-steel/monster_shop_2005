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
end

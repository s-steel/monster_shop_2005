class User < ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip, :email, :password

  validates_uniqueness_of :email

  has_many :orders
  belongs_to :merchant, optional: true

  has_secure_password

  enum role: %w(default merchant_employee admin)
end

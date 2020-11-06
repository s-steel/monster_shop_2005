class User < ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip, :email

  validates_uniqueness_of :email

  has_many :orders
  belongs_to :merchant, optional: true

  has_secure_password

  enum role: %w(default merchant_employee admin)

  def date_created
    created_at.strftime('%m/%d/%Y')
  end
end

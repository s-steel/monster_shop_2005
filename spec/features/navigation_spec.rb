
require 'rails_helper'

RSpec.describe 'Site Navigation' do
  describe 'As a Visitor' do
    it "I see a nav bar with links to all pages" do
      visit '/merchants'

      within 'nav' do
        click_link 'All Items'
      end

      expect(current_path).to eq('/items')

      within 'nav' do
        click_link 'All Merchants'
      end

      expect(current_path).to eq('/merchants')
    end

    it "I can see a cart indicator on all pages" do
      visit '/merchants'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end

      visit '/items'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end
    end

    it 'has link to home page' do
      visit '/merchants'

      within '.topnav' do
        click_link 'Home'
      end

      expect(current_path).to eq('/')
      expect(page).to have_content("Welcome to Monster Shop")
    end

    it 'has link to register' do
      visit '/merchants'

      within '.topnav' do
        click_link 'Register'
      end

      expect(current_path).to eq('/register')
    end

    it 'has link to login' do
      visit '/merchants'

      within '.topnav' do
        click_link 'Login'
      end

      expect(current_path).to eq('/login')
    end

    describe "When I try to access any unauthorized path" do
      it "does not allow visitor to see admin dashboard" do
        visit "/admin"

        expect(page).to have_content("The page you were looking for doesn't exist.")
      end

      it "does not allow visitor to see all users" do
        visit "/admin/users"

        expect(page).to have_content("The page you were looking for doesn't exist.")
      end

      it "does not allow visitor to see merchant dashboard" do
        visit "/merchant"

        expect(page).to have_content("The page you were looking for doesn't exist.")
      end
    end
  end
end

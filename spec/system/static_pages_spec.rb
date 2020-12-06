require 'rails_helper'

RSpec.describe "StaticPages", type: :system do
  def setup
    @base_title = "Ruby on Rails Tutorial Sample App"
  end

  describe "GET /home" do
    it "display correct title" do
      visit root_path
      expect(page).to have_title "#{@base_title}"
    end

    it "has correct layout links" do
      visit root_path
      expect(page).to have_link "sample app"
      expect(page).to have_link "Home"
      expect(page).to have_link "Help"
      expect(page).to have_link "About"
      expect(page).to have_link "Contact"
      expect(page).to have_link "Sign up now!"
      click_link "Contact"
      expect(page).to have_title "Contact | #{@base_title}"
      click_link "Home"
      expect(current_path).to eq root_path
      click_link "Sign up now!"
      expect(page).to have_title "Sign up | #{@base_title}"
    end
  end

  describe "GET /help" do
    it "display correct title" do
      visit help_path
      expect(page).to have_title "Help | #{@base_title}"
    end
  end

  describe "GET /about" do
    it "display correct title" do
      visit about_path
      expect(page).to have_title "About | #{@base_title}"
    end
  end

  describe "GET /contact" do
    it "display correct title" do
      visit contact_path
      expect(page).to have_title "Contact | #{@base_title}"
    end
  end
end

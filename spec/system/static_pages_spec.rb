require 'rails_helper'

RSpec.describe "StaticPages", type: :system do
  def setup
    @base_title = "Ruby on Rails Tutorial Sample App"
  end

  describe "GET /home" do
    it "display correct title" do
      visit root_path
      expect(page).to have_title "Home | #{@base_title}"
    end
  end

  describe "GET /help" do
    it "display correct title" do
      visit static_pages_help_path
      expect(page).to have_title "Help | #{@base_title}"
    end
  end

  describe "GET /about" do
    it "display correct title" do
      visit static_pages_about_path
      expect(page).to have_title "About | #{@base_title}"
    end
  end

  describe "GET /contact" do
    it "display correct title" do
      visit static_pages_contact_path
      expect(page).to have_title "Contact | #{@base_title}"
    end
  end
end

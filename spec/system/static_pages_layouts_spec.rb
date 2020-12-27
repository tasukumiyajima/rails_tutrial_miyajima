require 'rails_helper'

RSpec.describe "StaticPages_layout", type: :system do
  def setup
    @base_title = "Ruby on Rails Tutorial Sample App"
  end
  subject { page }

  describe "GET /home" do
    it "display correct title" do
      visit root_path
      is_expected.to have_title "#{@base_title}"
    end

    it "has correct layout links when not login" do
      visit root_path
      is_expected.to have_link "sample app"
      is_expected.to have_link "Home"
      is_expected.to have_link "Help"
      is_expected.to have_link "About"
      is_expected.to have_link "Contact"
      is_expected.to have_link "Sign up now!"
      is_expected.to have_link "Log in"
      click_link "Contact"
      is_expected.to have_title "Contact | #{@base_title}"
      click_link "Home"
      expect(current_path).to eq root_path
      click_link "Sign up now!"
      is_expected.to have_title "Sign up | #{@base_title}"
    end
  end

  describe "GET /help" do
    it "display correct title" do
      visit help_path
      is_expected.to have_title "Help | #{@base_title}"
    end
  end

  describe "GET /about" do
    it "display correct title" do
      visit about_path
      is_expected.to have_title "About | #{@base_title}"
    end
  end

  describe "GET /contact" do
    it "display correct title" do
      visit contact_path
      is_expected.to have_title "Contact | #{@base_title}"
    end
  end
end

require 'rails_helper'

RSpec.describe "Login", type: :system do
  subject { page }

  let!(:user) { create(:user) }

  before do
    visit login_path
  end

  context "with invalid email and password" do
    before do
      fill_in "Email", with: ""
      fill_in "Password", with: ""
      click_button "Log in"
    end

    it "gets an error flash message at only one time" do
      is_expected.to have_selector(".alert-danger", text: "Invalid email/password combination")
      is_expected.to have_current_path login_path
      visit root_path
      is_expected.not_to have_selector(".alert-danger", text: "Invalid email/password combination")
    end
  end

  context "with valid email and invalid password" do
    before do
      visit login_path
      fill_in "Email", with: user.email
      fill_in "Password", with: ""
      click_button "Log in"
    end

    it "gets an error flash message" do
      is_expected.to have_selector(".alert-danger", text: "Invalid email/password combination")
      is_expected.to have_current_path login_path
    end
  end

  context "with valid email and password" do
    before do
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      click_button "Log in"
    end

    it "dispalys user-page after login" do
      is_expected.to have_current_path user_path(user)
      is_expected.not_to have_link nil, href: login_path
      click_link "Account"
      is_expected.to have_link "Profile", href: user_path(user)
      is_expected.to have_link "Log out", href: logout_path
    end

    it "logout after login" do
      click_link "Account"
      click_link "Log out"
      is_expected.to have_current_path root_path
      is_expected.to have_link "Log in", href: login_path
      is_expected.not_to have_link "Account"
      is_expected.not_to have_link nil, href: logout_path
      is_expected.not_to have_link nil, href: user_path(user)
    end
  end
end

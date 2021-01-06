require 'rails_helper'

RSpec.describe "Users_signup", type: :system do
  def setup
    ActionMailer::Base.deliveries.clear
  end

  context "with correct values" do
    subject { page }

    before do
      visit signup_path
      fill_in 'Name', with: 'Example User'
      fill_in 'Email', with: 'user@example.com'
      fill_in 'Password', with: 'password'
      fill_in 'Password confirmation', with: 'password'
      click_button 'Create my account'
    end

    it "login as a new user" do
      is_expected.to have_selector(
        ".alert-info",
        text: "Please check your email to activate your account.",
      )
      is_expected.to have_current_path root_path
    end
  end

  context "with incorrect values" do
    subject { page }

    before do
      visit signup_path
      fill_in "Name", with: ""
      fill_in "Email", with: ""
      fill_in "Password", with: ""
      fill_in "Password confirmation", with: ""
      click_button "Create my account"
    end

    it "gets an error" do
      is_expected.to have_selector("#error_explanation")
      is_expected.to have_selector(".alert-danger", text: "The form contains 4 errors.")
      is_expected.to have_content("Password can't be blank", count: 1)
    end

    it "render to /users url" do
      is_expected.to have_current_path "/users"
    end
  end
end

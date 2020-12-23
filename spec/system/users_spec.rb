require 'rails_helper'

RSpec.describe "Users", type: :system do
  describe "create an new user" do
    context "with correct values" do
      subject { page }

      before do
        visit signup_path
        fill_in 'Name', with: 'Example User'
        fill_in 'Email', with: 'user@example.com'
        fill_in 'Password', with: 'password'
        fill_in 'Confirmation', with: 'password'
        click_button 'Create my account'
      end

      it "gets an flash message" do
        is_expected.to have_selector(".alert-success", text: "Welcome to the Sample App!")
      end

      it "render to /users url" do
        is_expected.to have_current_path user_path(User.last)
      end
    end

    context "with incorrect values" do
      subject { page }

      before do
        visit signup_path
        fill_in "Name", with: ""
        fill_in "Email", with: ""
        fill_in "Password", with: ""
        fill_in "Confirmation", with: ""
        click_button "Create my account"
      end

      it "gets an error" do
        is_expected.to have_selector("#error_explanation")
        is_expected.to have_selector(".alert-danger", text: "The form contains 6 errors.")
        is_expected.to have_content("Password can't be blank", count: 2)
      end

      it "render to /users url" do
        is_expected.to have_current_path "/users"
      end
    end
  end
end

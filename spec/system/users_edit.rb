require 'rails_helper'

RSpec.describe "Users_edit", type: :system do
  let(:user) { create(:user) }

  context "with valid infomation" do
    it "edit successfuly with friendly forwarding" do
      visit edit_user_path(user)
      expect(current_path).to eq login_path
      log_in_as(user)
      expect(current_path).to eq user_edit_path(user)
      fill_in 'Name', with: 'foobar'
      fill_in 'Email', with: 'foobar@example.com'
      fill_in 'Password', with: ''
      fill_in 'Password confirmation', with: ''
      click_button 'Save changes'
      expect(current_path).to eq user_path(user)
      expect(page).to have_selector(".alert-success", text: "Profile updated")
      expect(user.reload.name).to eq "foobar"
      expect(user.reload.email).to eq "foobar@example.com"
    end
  end

  context "with invalid infomation" do
    it "doesn't edit" do
      log_in_as(user)
      visit edit_user_path(user)
      fill_in 'Name', with: ""
      fill_in 'Email', with: "foo@invalid"
      fill_in 'Password', with: 'foo'
      fill_in 'Password confirmation', with: 'bar'
      click_button 'Save changes'
      expect(current_path).to eq user_edit_path(user)
      expect(page).to have_selector(".alert-danger", text: "The form contains 4 errors.")
      expect(user.reload.email).to eq user.email
    end
  end
end

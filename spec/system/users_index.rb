require 'rails_helper'

RSpec.describe "Users_index", type: :system do
  let(:user) { create(:user) }
  let!(:admin_user) { create(:user, :admin) }
  let!(:other_users) { create_list(:user, 60) }

  it "index as admin including pagination and delete links" do
    log_in_as(admin_user)
    visit users_path
    expect(page).to have_selector(".pagination", count: 4)
    expect(User.paginate(page: 1).length).to eq 30
    User.paginate(page: 1).each do |user|
      expect(page).to have_link "#{user.name}", href: user_path(user)
      unless user == admin_user
        expect(page).to have_link "delete", href: user_path(user)
      end
    end
  end

  it "index as non-admin" do
    log_in_as(user)
    visit users_path
    expect(page).to have_no_content("delete")
  end
end

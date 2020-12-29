require 'rails_helper'

RSpec.describe "Users_index", type: :system do
  let(:user) { create(:user) }
  let!(:admin_user) { create(:user, :admin) }
  let!(:other_users) { create_list(:user, 60) }
  let!(:non_acitve_user) { create(:user, :no_activated) }

  it "includes pagination and delete links when logged in as admin user" do
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

  it "includes no delete links when logged in as non-admin user" do
    log_in_as(user)
    visit users_path
    expect(page).to have_no_content("delete")
  end

  it "doesn't include non acitivated user" do
    log_in_as(user)
    visit users_path
    expect(User.paginate(page: 3).length).not_to eq 30
    expect(User.paginate(page: 3)).not_to have_link "#{non_acitve_user.name}"
  end
end

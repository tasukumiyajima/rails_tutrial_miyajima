require 'rails_helper'

RSpec.describe "Followings", type: :system do
  let(:user) { create(:user) }
  let(:other_users) { create_list(:user, 20) }

  before do
    # userがother_usersの初めの10人をフォローして、同時にフォローされる
    other_users[0..9].each do |other_user|
      user.active_relationships.create!(followed_id: other_user.id)
      user.passive_relationships.create!(follower_id: other_user.id)
    end
    log_in_as(user)
  end

  it "show correct numbers of followings and followers" do
    click_on "following"
    expect(user.following.count).to eq 10
    user.following.each do |following|
      expect(page).to have_link following.name, href: user_path(following)
    end

    click_on "followers"
    expect(user.followers.count).to eq 10
    user.followers.each do |follower|
      expect(page).to have_link follower.name, href: user_path(follower)
    end
  end

  it "decreases the number of following when click on Unfollow" do
    # userがfollowしているother_users
    visit user_path(other_users.first.id)
    expect do
      click_on "Unfollow"
      expect(page).not_to have_link "Unfollow"
      visit current_path
    end.to change(user.following, :count).by(-1)
  end

  it "increases the number of following when click on Follow" do
    # userがfollowしていないother_users
    visit user_path(other_users.last.id)
    expect do
      click_on "Follow"
      expect(page).not_to have_link "Follow"
      visit current_path
    end.to change(user.following, :count).by(1)
  end

  it "show feed on Homepage" do
    visit root_path
    user.feed.paginate(page: 1).each do |micropost|
      expect(page).to have_content CGI.escapeHTML(micropost.content)
    end
  end
end

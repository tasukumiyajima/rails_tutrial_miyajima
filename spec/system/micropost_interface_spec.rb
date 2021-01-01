require 'rails_helper'

RSpec.describe "MicropostsInterfaces", type: :system do
  context "when microposts are created at same time" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let!(:microposts) { create_list(:micropost, 35, user_id: user.id) }
    let!(:other_microposts) { create_list(:micropost, 35, user_id: other_user.id) }

    it "display correct user show page" do
      log_in_as(user)
      expect(current_path).to eq user_path(user)
      expect(page).to have_title "#{user.name}"
      expect(page).to have_selector("h1", text: "#{user.name}")
      expect(page).to have_selector("h1>img.gravatar")
      expect(page).to have_content("#{user.microposts.count}")
      expect(page).to have_selector(".pagination", count: 2)
      user.microposts.paginate(page: 1).each do |micropost|
        expect(page).to have_content "#{micropost.content}"
      end
    end

    it "makes and deletes micropost correctly from root_path" do
      log_in_as(user)
      visit root_path
      # 無効な送信
      click_on "Post"
      expect(has_css?('.alert-danger')).to be_truthy
      # 正しいページネーションリンク
      click_on "2"
      expect(URI.parse(current_url).query).to eq "page=2"
      # 有効な送信
      content = "This micropost really ties the room together"
      fill_in "micropost_content", with: content
      attach_file 'micropost[image]', "#{Rails.root}/spec/factories/kitten.jpg"
      expect do
        click_on "Post"
        expect(current_path).to eq root_path
        expect(has_css?('.alert-success')).to be_truthy
        expect(page).to have_selector "img[src$='kitten.jpg']"
      end.to change(Micropost, :count).by(1)
      # 投稿を削除する
      expect do
        first("a", text: "delete").click
        expect(current_path).to eq root_path
        expect(has_css?('.alert-success')).to be_truthy
      end.to change(Micropost, :count).by(-1)
      # 違うユーザのプロフィールにアクセス(削除リンクがないことを確認)
      visit user_path(other_user)
      expect(page).not_to have_link "delete"
    end
  end

  context "when microposts are created at different time" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let!(:day_before_yesterday) { create(:micropost, :day_before_yesterday, user_id: user.id) }
    let!(:yesterday) { create(:micropost, :yesterday, user_id: user.id) }
    let!(:now) { create(:micropost, :now, user_id: other_user.id) }

    before do
      user.active_relationships.create!(followed_id: other_user.id)
    end

    it "first micropost on homepage is latest one" do
      log_in_as(user)
      visit root_path
      first("li>.user>a").click
      expect(current_path).to eq user_path(other_user)
    end
  end
end

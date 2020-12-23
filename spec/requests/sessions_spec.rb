require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  let!(:user) { create(:user) }

  describe "GET /new" do
    it "returns https success" do
      get login_path
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /create" do
    it "redirect to user_path" do
      post login_path, params: { session: { email: user.email, password: user.password } }
      expect(response). to redirect_to user_path(user)
      expect(is_logged_in?).to be_truthy
    end
  end

  describe "DELETE /destroy" do
    it "redirect to root_path" do
      post login_path, params: { session: { email: user.email, password: user.password } }
      delete logout_path
      expect(response).to redirect_to root_path
      expect(is_logged_in?).to be_falsey
    end
  end
end

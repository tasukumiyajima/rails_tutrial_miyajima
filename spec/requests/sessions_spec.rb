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
    context "login with remembering" do
      it "remembers cookies" do
        post login_path, params: { session: {
          email: user.email,
          password: user.password,
          remember_me: "1",
        } }
        expect(response.cookies["remember_token"]).not_to eq nil
      end
    end

    context "login without remembering" do
      it "redirect to user_path" do
        post login_path, params: { session: {
          email: user.email,
          password: user.password,
          remember_me: "0",
        } }
        expect(response).to redirect_to user_path(user)
        expect(is_logged_in?).to be_truthy
      end

      it "doesn't remember cookies" do
        post login_path, params: { session: {
          email: user.email,
          password: user.password,
          remember_me: "1",
        } }
        delete logout_path
        post login_path, params: { session: {
          email: user.email,
          password: user.password,
          remember_me: "0",
        } }
        expect(response.cookies["remember_token"]).to eq nil
      end
    end
  end

  describe "DELETE /destroy" do
    it "redirect to root_path" do
      post login_path, params: { session: { email: user.email, password: user.password } }
      delete logout_path
      expect(response).to redirect_to root_path
      expect(is_logged_in?).to be_falsey
      delete logout_path
      expect(response). to have_http_status 302
      expect(is_logged_in?).to be_falsey
    end
  end
end

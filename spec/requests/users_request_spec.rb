require 'rails_helper'

RSpec.describe "Users_requests", type: :request do
  let(:user) { create(:user) }
  let!(:other_user) { create(:user, name: "Archer", email: "duchess@example.gov") }
  let!(:admin_user) { create(:user, :admin) }
  let!(:non_acitve_user) { create(:user, :no_activated) }

  describe "GET /new" do
    it "returns http success" do
      get signup_path
      expect(response).to have_http_status 200
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get user_path(user)
      expect(response).to have_http_status 200
    end

    it "redirect to root_path when user is not activated" do
      get user_path(non_acitve_user)
      expect(response).to have_http_status 302
      expect(response).to redirect_to root_path
    end
  end

  describe "GET /index" do
    it "redirect to login_url when not login" do
      get users_path
      expect(response).to have_http_status 302
      expect(response).to redirect_to login_url
    end

    it "returns http success when logged in" do
      post login_path, params: { session: { email: user.email, password: user.password } }
      get users_path
      expect(response).to have_http_status 200
    end
  end

  describe "POST /create" do
    context "with invalid request" do
      let(:user_params) do
        attributes_for(:user, name: "",
                              email: "user@invalid",
                              password: "foo",
                              password_confirmation: "bar")
      end

      it "does not add a user" do
        expect do
          post users_path, params: { user: user_params }
        end.to change(User, :count).by(0)
      end

      it "returns http success" do
        post users_path, params: { user: user_params }
        expect(response).to have_http_status 200
      end
    end

    context "with valid request" do
      it "add a user" do
        expect do
          post users_path, params: { user: attributes_for(:user) }
        end.to change(User, :count).by(1)
        expect(ActionMailer::Base.deliveries.size).to eq 1
      end

      it "redirect to user_path" do
        post users_path, params: { user: attributes_for(:user) }
        expect(response).to have_http_status 302
        expect(response).to redirect_to root_path
        expect(is_logged_in?).to be_falsy
      end
    end
  end

  describe "GET /edit" do
    it "friendly forwarding" do
      get edit_user_path(user)
      expect(response).to have_http_status 302
      expect(response).to redirect_to login_url
      post login_path, params: { session: { email: user.email, password: user.password } }
      expect(response).to redirect_to edit_user_path(user)
    end

    it "redirect to login_url when not login" do
      get edit_user_path(user)
      expect(response).to have_http_status 302
      expect(response).to redirect_to login_url
    end

    it "redirect to login_url when login as other user" do
      post login_path, params: { session: {
        email: other_user.email,
        password: other_user.password,
      } }
      get edit_user_path(user)
      expect(response).to have_http_status 302
      expect(response).to redirect_to root_url
    end

    it "returns http success when login as user" do
      post login_path, params: { session: { email: user.email, password: user.password } }
      get edit_user_path(user)
      expect(response).to have_http_status 200
    end
  end

  describe "PATCH /update" do
    it "redirect to login_url when not login" do
      patch user_path(user), params: { user: {
        name: user.name,
        email: user.email,
      } }
      expect(response).to have_http_status 302
      expect(response).to redirect_to login_url
    end

    it "redirect to login_url when login as other user" do
      post login_path, params: { session: {
        email: other_user.email,
        password: other_user.password,
      } }
      patch user_path(user), params: { user: {
        name: user.name,
        email: user.email,
      } }
      expect(response).to have_http_status 302
      expect(response).to redirect_to root_url
    end

    it "redirect to user_path when login as user" do
      post login_path, params: { session: { email: user.email, password: user.password } }
      patch user_path(user), params: { user: {
        name: user.name,
        email: user.email,
      } }
      expect(response).to have_http_status 302
      expect(response).to redirect_to user_path(user)
    end

    it "does not allow the admin attribute to be edited via the web" do
      post login_path, params: { session: { email: user.email, password: user.password } }
      patch user_path(user), params: { user: {
        password: "password",
        password_confirmation: "password",
        admin: true,
      } }
      expect(user.admin).to eq false
    end
  end

  describe "DELETE /destroy" do
    it "redirects destroy when not logged in" do
      expect do
        delete user_path(other_user)
      end.to change(User, :count).by(0)
      expect(response).to redirect_to login_url
    end

    it "redirects destroy when logged in as a non-adomin" do
      post login_path, params: { session: { email: user.email, password: user.password } }
      expect do
        delete user_path(other_user)
      end.to change(User, :count).by(0)
      expect(response).to redirect_to root_url
    end

    it "destroy a user when logged in as admin user" do
      post login_path, params: { session: {
        email: admin_user.email,
        password: admin_user.password,
      } }
      expect do
        delete user_path(other_user)
      end.to change(User, :count).by(-1)
      expect(response).to redirect_to users_url
    end
  end

  describe "GET /following" do
    it "redirect when not logged in" do
      get following_user_path(user)
      expect(response). to redirect_to login_url
    end
  end

  describe "GET /followers" do
    it "redirect when not logged in" do
      get followers_user_path(user)
      expect(response). to redirect_to login_url
    end
  end
end

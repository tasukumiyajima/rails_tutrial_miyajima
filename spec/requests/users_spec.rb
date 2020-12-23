require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get signup_path
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
      end

      it "redirect to user_path" do
        post users_path, params: { user: attributes_for(:user) }
        expect(response).to have_http_status 302
        expect(response).to redirect_to user_path(User.last)
      end

      it "log in" do
        post users_path, params: { user: attributes_for(:user) }
        expect(is_logged_in?).to be_truthy
      end
    end
  end
end

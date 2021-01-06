require 'rails_helper'

RSpec.describe "PasswordResets", type: :request do
  let!(:user) { create(:user) }

  before { user.create_reset_digest }

  describe "GET /new" do
    it "returns http success" do
      get new_password_reset_path
      expect(response).to have_http_status 200
      expect(response.body).to include 'Forgot password'
    end
  end

  describe "POST /create" do
    it 'falis create with invalid email' do
      post password_resets_path, params: { password_reset: { email: "" } }
      expect(response).to have_http_status 200
      expect(response.body).to include 'Forgot password'
    end

    it 'succeds create with valid email' do
      post password_resets_path, params: { password_reset: { email: user.email } }
      expect(user.reset_digest).not_to eq user.reload.reset_digest
      expect(ActionMailer::Base.deliveries.size).to eq 1
      expect(response).to redirect_to root_url
    end
  end

  describe "GET /edit" do
    context 'when user sends correct token and wrong email' do
      before { get edit_password_reset_path(user.reset_token, email: "") }

      it 'redirect to root_url' do
        expect(response).to redirect_to root_url
      end
    end

    context 'when not activated user sends correct token and email' do
      before do
        user.toggle!(:activated)
        get edit_password_reset_path(user.reset_token, email: user.email)
      end

      it 'fails' do
        expect(response).to redirect_to root_url
      end
    end

    context 'when user sends wrong token and correct email' do
      before { get edit_password_reset_path("wrong", email: user.email) }

      it 'fails' do
        expect(response).to redirect_to root_url
      end
    end

    context 'when user sends correct token and email' do
      before { get edit_password_reset_path(user.reset_token, email: user.email) }

      it 'succeeds' do
        expect(response).to have_http_status(200)
        expect(response.body).to include "Reset password"
      end
    end
  end

  describe "PATCH /update" do
    context "when user sends wrong password" do
      before do
        patch password_reset_path(user.reset_token),
              params: {
                email: user.email,
                user: {
                  password: "foobaz",
                  password_confirmation: "barquux",
                },
              }
      end

      it 'render to get /edit' do
        expect(response).to have_http_status 200
        expect(response.body).to include "Reset password"
      end
    end

    context "when user patch /updates after 3 hours" do
      before do
        user.update_attribute(:reset_sent_at, 3.hours.ago)
        patch password_reset_path(user.reset_token),
              params: {
                email: user.email,
                user: {
                  password: "foobar",
                  password_confirmation: "foobar",
                },
              }
      end

      it "redirect to get new" do
        expect(response).to redirect_to new_password_reset_url
      end
    end

    context "when user sends blank password" do
      before do
        patch password_reset_path(user.reset_token),
              params: {
                email: user.email,
                user: {
                  password: "",
                  password_confirmation: "",
                },
              }
      end

      it 'render to get /edit' do
        expect(response).to have_http_status 200
        expect(response.body).to include "Reset password"
      end
    end

    context "when user sends correct password" do
      before do
        patch password_reset_path(user.reset_token),
              params: {
                email: user.email,
                user: {
                  password: "foobaz",
                  password_confirmation: "foobaz",
                },
              }
      end

      it 'login as user' do
        expect(is_logged_in?).to be_truthy
        expect(user.reload.reset_digest).to eq nil
        expect(response).to redirect_to user
      end
    end
  end
end

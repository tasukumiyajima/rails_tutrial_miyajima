require 'rails_helper'

RSpec.describe "AccountActivations", type: :request do
  describe "GET /edit" do
    let(:non_acitve_user) { create(:user, :no_activated) }

    context "without activation process" do
      it "fails login" do
        post login_path, params: { session: {
          email: non_acitve_user.email,
          password: non_acitve_user.password,
        } }
        expect(is_logged_in?).to be_falsy
        expect(response).to redirect_to root_url
      end
    end

    context 'with wrong token and right email' do
      before do
        get edit_account_activation_path(
          'invalid token',
          email: non_acitve_user.email,
        )
      end

      it "falis login" do
        expect(is_logged_in?).to be_falsy
        expect(response).to redirect_to root_url
      end
    end

    context 'with right token and wrong email' do
      before do
        get edit_account_activation_path(
          non_acitve_user.activation_token,
          email: 'wrong',
        )
      end

      it "falis login" do
        expect(is_logged_in?).to be_falsy
        expect(response).to redirect_to root_url
      end
    end

    context 'with right token and right email' do
      before do
        get edit_account_activation_path(
          non_acitve_user.activation_token,
          email: non_acitve_user.email,
        )
      end

      it "succeeds login" do
        expect(is_logged_in?).to be_truthy
        expect(response).to redirect_to non_acitve_user
      end
    end
  end
end

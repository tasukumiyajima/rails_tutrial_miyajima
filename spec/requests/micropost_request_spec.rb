require 'rails_helper'

RSpec.describe "Microposts", type: :request do
  describe "POST /create" do
    let(:micropost) { attributes_for(:micropost) }
    let(:post_request) { post microposts_path, params: { micropost: micropost } }

    context "when not logged in" do
      it "doesn't change Micropost's count" do
        expect do
          post_request
        end.to change(Micropost, :count).by(0)
      end

      it "redirects to login_url" do
        expect(post_request).to redirect_to login_url
      end
    end
  end

  describe "DELETE /destroy" do
    let!(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let!(:micropost) { create(:micropost, user_id: user.id) }

    context "when not logged in" do
      it "doesn't delete micropost" do
        expect do
          delete micropost_path(micropost)
        end.to change(Micropost, :count).by(0)
      end

      it "redirects to login_url" do
        delete micropost_path(micropost)
        expect(response).to redirect_to login_url
      end
    end

    context "when logged in as other_user" do
      before do
        post login_path, params: { session: {
          email: other_user.email,
          password: other_user.password,
        } }
      end

      it "doesn't delete user's micropost" do
        expect do
          delete micropost_path(micropost)
        end.to change(Micropost, :count).by(0)
      end

      it "redirects to root url" do
        delete micropost_path(micropost)
        expect(response).to redirect_to root_url
      end
    end
  end
end

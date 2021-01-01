require 'rails_helper'

RSpec.describe "Relationships", type: :request do
  describe "POST /create" do
    context "when not logged in" do
      it "doesn't change Relationship's count" do
        expect do
          post relationships_path
        end.to change(Relationship, :count).by(0)
      end

      it "redirects to login_url" do
        post relationships_path
        expect(response).to redirect_to login_url
      end
    end
  end

  describe "DELETE /destroy" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    before { user.following << other_user }

    context "when not logged in" do
      it "doesn't change Relationship's count" do
        expect do
          delete relationship_path(other_user)
        end.to change(Relationship, :count).by(0)
      end

      it "redirects to login_url" do
        delete relationship_path(other_user)
        expect(response).to redirect_to login_url
      end
    end
  end
end

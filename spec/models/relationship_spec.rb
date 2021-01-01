require 'rails_helper'

RSpec.describe Relationship, type: :model do
  describe "" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:relationship) { user.active_relationships.build(followed_id: other_user.id) }

    it "is valid with test data" do
      expect(relationship).to be_valid
    end

    it "is invalid without follower_id" do
      relationship.follower_id = nil
      expect(relationship).to be_invalid
    end

    it "is invalid without followed_id" do
      relationship.followed_id = nil
      expect(relationship).to be_invalid
    end
  end

  describe "follow and unfollow" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    before { user.follow(other_user) }

    describe "follow" do
      it "succeeds" do
        expect(user.following?(other_user)).to be_truthy
      end
    end

    describe "followers" do
      it "succeeds" do
        expect(other_user.followers.include?(user)).to be_truthy
      end
    end

    describe "unfollow" do
      it "succeeds" do
        user.unfollow(other_user)
        expect(user.following?(other_user)).to be_falsy
      end
    end
  end
end

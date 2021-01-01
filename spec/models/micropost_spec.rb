require 'rails_helper'

RSpec.describe Micropost, type: :model do
  describe "valildation and association" do
    let(:micropost) { create(:micropost) }

    it "is valid with micropost's test data" do
      expect(micropost).to be_valid
    end

    it "is invalid with no user_id" do
      micropost.user_id = nil
      expect(micropost).to be_invalid
    end

    it "is invalid with no content" do
      micropost.content = " "
      expect(micropost).to be_invalid
    end

    it "is invalid with 141-letter mails" do
      micropost.content = "a" * 141
      expect(micropost).to be_invalid
    end
  end
end

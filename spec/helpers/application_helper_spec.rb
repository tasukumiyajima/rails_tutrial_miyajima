require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe "full_title" do
    context "without page title" do
      it "returns only base title" do
        expect(full_title("")).to eq("Ruby on Rails Tutorial Sample App")
        expect(full_title(nil)).to eq("Ruby on Rails Tutorial Sample App")
      end
    end

    context "with page title" do
      it "returns full title" do
        expect(full_title("Help")).to eq("Help | Ruby on Rails Tutorial Sample App")
      end
    end
  end
end

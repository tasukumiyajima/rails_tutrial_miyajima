require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  describe "GET /home" do
    it "returns https success" do
      get root_url
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /help" do
    it "returns https success" do
      get static_pages_help_url
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /about" do
    it "returns https success" do
      get static_pages_about_url
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /contact" do
    it "returns https success" do
      get static_pages_contact_url
      expect(response).to have_http_status(200)
    end
  end
end

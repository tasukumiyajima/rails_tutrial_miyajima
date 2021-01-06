require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  describe "GET /home" do
    it "returns https success" do
      get root_url
      expect(response).to have_http_status(200)
    end

    it "displays correct body" do
      get root_url
      expect(response.body).to include "Welcome to the Sample App"
    end
  end

  describe "GET /help" do
    it "returns https success" do
      get help_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /about" do
    it "returns https success" do
      get about_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /contact" do
    it "returns https success" do
      get contact_path
      expect(response).to have_http_status(200)
    end
  end
end

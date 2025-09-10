require 'rails_helper'

RSpec.describe "Api::V1::Followings", type: :request do
  let(:user) { create(:user) }
  let(:followed_user) { create(:user, name: "Alice") }
  let(:other_user) { create(:user, name: "Bob") }

  describe "GET /api/v1/users/:user_id/followings" do
    before do
      user.follow(followed_user)
      user.follow(other_user)
    end

    it "returns all followings" do
      get api_v1_user_followings_path(user_id: user.id)
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["followings"].size).to eq(2)
    end

    it "filters followings by name" do
      get api_v1_user_followings_path(user_id: user.id), params: { name: "ali" }
      expect(response).to have_http_status(:ok)
      followings = JSON.parse(response.body)["followings"]
      expect(followings.size).to eq(1)
      expect(followings.first["name"]).to eq("Alice")
    end

    it "paginates followings" do
      get api_v1_user_followings_path(user_id: user.id), params: { per_page: 1, page: 2 }
      expect(response).to have_http_status(:ok)
      pagination = JSON.parse(response.body)["pagination"]
      expect(pagination["current_page"]).to eq(2)
      expect(pagination["per_page"]).to eq(1)
      expect(JSON.parse(response.body)["followings"].size).to eq(1)
    end
  end
end

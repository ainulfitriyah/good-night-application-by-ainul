require 'rails_helper'

RSpec.describe Api::V1::FollowingsController, type: :controller do
  let(:user) { create(:user) }
  let(:followed_user) { create(:user, name: "Alice") }
  let(:other_user) { create(:user, name: "Bob") }


  describe "GET #index" do
    before do
      user.follow(followed_user)
      user.follow(other_user)
    end

    it "returns all followings" do
      get :index, params: { user_id: user.id }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["followings"].size).to eq(2)
    end

    it "filters followings by name" do
      get :index, params: { user_id: user.id, name: "ali" }
      expect(response).to have_http_status(:ok)
      followings = JSON.parse(response.body)["followings"]
      expect(followings.size).to eq(1)
      expect(followings.first["name"]).to eq("Alice")
    end

    it "paginates followings" do
      get :index, params: { user_id: user.id, per_page: 1, page: 2 }
      expect(response).to have_http_status(:ok)
      pagination = JSON.parse(response.body)["pagination"]
      expect(pagination["current_page"]).to eq(2)
      expect(pagination["per_page"]).to eq(1)
      expect(JSON.parse(response.body)["followings"].size).to eq(1)
    end
  end
end

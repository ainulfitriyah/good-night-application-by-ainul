# spec/requests/api/v1/followings_controller_spec.rb
require 'rails_helper'

RSpec.describe "Api::V1::Followings", type: :request do
  let(:user) { create(:user) }
  let(:target_user) { create(:user) }
  let(:headers) { { "CONTENT_TYPE" => "application/json" } }

  describe "POST /api/v1/users/:user_id/followings" do
    context "when target user exists and not already followed" do
      it "follows the user and returns created" do
        post "/api/v1/users/#{user.id}/followings", params: { target_user_id: target_user.id }.to_json, headers: headers
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to include("message" => "Now following", "following" => true)
      end
    end

    context "when target user does not exist" do
      it "returns not found" do
        post "/api/v1/users/#{user.id}/followings", params: { target_user_id: 0 }.to_json, headers: headers
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to include("error" => "Target user not found")
      end
    end

    context "when already following the target user" do
      before { user.follow(target_user) }

      it "returns already following" do
        post "/api/v1/users/#{user.id}/followings", params: { target_user_id: target_user.id }.to_json, headers: headers
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include("message" => "Already following", "following" => true)
      end
    end
  end
end

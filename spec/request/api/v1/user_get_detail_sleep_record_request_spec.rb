require 'rails_helper'

RSpec.describe "Api::V1::MySleepRecords", type: :request do
  let(:user) { create(:user) }
  let(:headers) { { "CONTENT_TYPE" => "application/json" } }

  describe "GET /api/v1/users/:user_id/my_sleep_records/:id" do
    context "when the sleep record exists" do
      let(:sleep_record) { create(:sleep_record, user: user) }

      it "returns the sleep record" do
        get "/api/v1/users/#{user.id}/my_sleep_records/#{sleep_record.id}", headers: headers
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["id"]).to eq(sleep_record.id)
      end
    end

    context "when the sleep record does not exist" do
      it "returns not found" do
        get "/api/v1/users/#{user.id}/my_sleep_records/0", headers: headers
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)["error"]).to eq("Sleep record not found")
      end
    end
  end
end

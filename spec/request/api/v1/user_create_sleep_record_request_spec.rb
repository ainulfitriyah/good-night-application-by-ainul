require 'rails_helper'

RSpec.describe "Api::V1::MySleepRecords", type: :request do
  let!(:user) { create(:user) }

  describe "POST /api/v1/my_sleep_records" do
    context "Unauthorized user" do
      it "returns unauthorized" do
        post "/api/v1/users/0/my_sleep_records"
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)["error"]).to eq("Unauthorized")
      end
    end

    context "when there is an active sleep record" do
      let!(:active_sleep_record) { create(:sleep_record, user: user, woke_at: nil) }

      it "ends the active sleep record" do
        expect {
          post "/api/v1/users/#{user.id}/my_sleep_records"
        }.to change { active_sleep_record.reload.woke_at }.from(nil)
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["message"]).to eq("Sleep record ended")
      end
    end

    context "when there is no active sleep record" do
      it "starts a new sleep record" do
        expect {
          post "/api/v1/users/#{user.id}/my_sleep_records"
        }.to change { user.sleep_records.count }.by(1)
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)["message"]).to eq("Sleep record started")
      end
    end
  end
end

# spec/controllers/api/v1/my_sleep_records_controller_spec.rb
require 'rails_helper'

RSpec.describe Api::V1::MySleepRecordsController, type: :controller do
  let!(:user) { create(:user) }

  describe "POST #create" do
    context "Unauthorized user" do
      it "Unauthorized" do
        post :create, params: { user_id: 'invalid' }
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)["error"]).to eq("Unauthorized")
      end
    end

    context "when there is an active sleep record" do
      let!(:active_sleep_record) { create(:sleep_record, user: user, woke_at: nil) }

      it "ends the active sleep record" do
        expect {
          post :create, params: { user_id: user.id }
        }.to change { active_sleep_record.reload.woke_at }.from(nil)
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["message"]).to eq("Sleep record ended")
      end
    end

    context "when there is no active sleep record" do
      it "starts a new sleep record" do
        expect {
          post :create, params: { user_id: user.id }
        }.to change { user.sleep_records.count }.by(1)
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)["message"]).to eq("Sleep record started")
      end
    end
  end
end

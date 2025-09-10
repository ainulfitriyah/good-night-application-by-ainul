require 'rails_helper'

RSpec.describe Api::V1::MySleepRecordsController, type: :controller do
  let(:user) { create(:user) }
  let!(:sleep_record1) { create(:sleep_record, user: user, slept_at: 2.days.ago) }
  let!(:sleep_record2) { create(:sleep_record, user: user, slept_at: 1.day.ago) }

  describe "GET /api/v1/users/:user_id/my_sleep_records" do
    it "returns paginated sleep records" do
      get :index, params: { user_id: user.id, page: 1, per_page: 1 }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['sleep_records'].length).to eq(1)
      expect(json['total_count']).to eq(1)
    end

    it "filters by date range" do
      get :index, params: {
        user_id: user.id,
        start_date: 3.days.ago.to_date.to_s,
        end_date: 1.day.ago.to_date.to_s
      }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['sleep_records'].length).to eq(2)
      expect(json['total_count']).to eq(2)
    end
  end
end

require 'rails_helper'

RSpec.describe 'Api::V1::FriendsSleepRecords', type: :request do
  let(:user) { create(:user) }
  let(:friend) { create(:user) }
  let!(:sleep_record1) { create(:sleep_record, user: friend, slept_at: 2.days.ago) }
  let!(:sleep_record2) { create(:sleep_record, user: friend, slept_at: 1.day.ago) }

  describe 'GET /api/v1/users/:user_id/friends_sleep_records' do
    before { user.follow(friend) }

    it 'returns sleep records of friends' do
      get "/api/v1/users/#{user.id}/friends_sleep_records"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['sleep_records'].size).to eq(2)
    end

    it 'filters by date range' do
      get "/api/v1/users/#{user.id}/friends_sleep_records", params: {
        start_date: 2.days.ago.to_date.to_s,
        end_date: 1.day.ago.to_date.to_s
      }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['sleep_records'].size).to eq(2)
    end

    it 'paginates results' do
      get "/api/v1/users/#{user.id}/friends_sleep_records", params: { per_page: 1, page: 2 }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['sleep_records'].size).to eq(1)
      expect(json['page']).to eq(2)
      expect(json['per_page']).to eq(1)
    end
  end
end

require 'rails_helper'

RSpec.describe 'Api::V1::MySleepRecords', type: :request do
  let(:user) { create(:user) }
  let(:target_user) { create(:user) }

  describe 'DELETE /api/v1/users/:user_id/followings' do
    context 'when target user exists and is followed' do
      before { user.follow(target_user) }

      it 'unfollows the user' do
        delete "/api/v1/users/#{user.id}/followings", params: { target_user_id: target_user.id }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq({ 'message' => 'Unfollowed', 'following' => false })
        expect(user.following?(target_user)).to be_falsey
      end
    end

    context 'when target user exists and is not followed' do
      it 'returns not following message' do
        delete "/api/v1/users/#{user.id}/followings", params: { target_user_id: target_user.id }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq({ 'message' => 'Not following', 'following' => false })
      end
    end

    context 'when target user does not exist' do
      it 'returns not found error' do
        delete "/api/v1/users/#{user.id}/followings", params: { target_user_id: 0 }
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to eq({ 'error' => 'Target user not found' })
      end
    end
  end
end

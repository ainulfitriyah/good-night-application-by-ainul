class Api::V1::MySleepRecordsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :define_current_user
  before_action :authorize_user

  # POST /api/v1/users/:user_id/my_sleep_records
  def create
    sleep_record_active = @current_user.sleep_records.active.first
    if sleep_record_active
      sleep_record_active.update(woke_at: DateTime.now)
      render json: { message: "Sleep record ended", sleep_record: sleep_record_active }, status: :ok
    else
      sleep_record = @current_user.sleep_records.create(slept_at: DateTime.now)
      render json: { message: "Sleep record started", sleep_record: sleep_record }, status: :created
    end
  end
end

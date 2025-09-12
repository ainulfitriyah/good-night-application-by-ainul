class Api::V1::MySleepRecordsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :define_current_user
  before_action :authorize_user

  # POST /api/v1/users/:user_id/my_sleep_records
  def create
    sleep_record_active = @current_user.sleep_records.active.first
    if sleep_record_active
      date_now = Time.now
      duration_seconds = (date_now - sleep_record_active.slept_at).to_i
      sleep_record_active.update(
        woke_at: date_now,
        duration_seconds: duration_seconds)
      render json: { message: "Sleep record ended", sleep_record: sleep_record_active }, status: :ok
    else
      sleep_record = @current_user.sleep_records.create(slept_at: DateTime.now)
      render json: { message: "Sleep record started", sleep_record: sleep_record }, status: :created
    end
  end

  # GET /api/v1/users/:user_id/my_sleep_records/:id
  def show
    sleep_record = @current_user.sleep_records.find_by(id: params[:id])
    if sleep_record
      render json: sleep_record, status: :ok
    else
      render json: { error: "Sleep record not found" }, status: :not_found
    end
  end

  # GET /api/v1/users/:user_id/my_sleep_records
  def index
    sleep_records = @current_user.sleep_records
    if params[:start_date].present? && params[:end_date].present?
      start_date = Date.parse(params[:start_date]) rescue nil
      end_date = Date.parse(params[:end_date]) rescue nil
      if start_date && end_date
        sleep_records = sleep_records.where(slept_at: start_date.beginning_of_day..end_date.end_of_day)
      end
    end
    sleep_records = sleep_records.order(duration_seconds: :desc)
    page = params[:page].to_i > 0 ? params[:page].to_i : 1
    per_page = params[:per_page].to_i > 0 ? params[:per_page].to_i : 20
    paginated = sleep_records.offset((page - 1) * per_page).limit(per_page)
    render json: {
      sleep_records: ActiveModelSerializers::SerializableResource.new(
        paginated,
        each_serializer: SleepRecordSerializer
      ),
      page: page,
      per_page: per_page,
      total_count: paginated.count
    }, status: :ok
  end
end

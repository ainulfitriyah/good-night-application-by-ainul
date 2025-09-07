class Api::V1::FollowingsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :define_current_user
  before_action :authorize_user

  # POST /api/v1/users/:user_id/followings
  def create
    target_user = User.find_by(id: params[:target_user_id])
    if target_user.nil?
      render json: { error: "Target user not found" }, status: :not_found
      return
    end

    if @current_user.following?(target_user)
      render json: { message: "Already following", following: true }, status: :ok
    else
      @current_user.follow(target_user)
      render json: { message: "Now following", following: true }, status: :created
    end
  end

  # DELETE /api/v1/users/:user_id/followings
  def destroy
    target_user = User.find_by(id: params[:target_user_id])
    if target_user.nil?
      render json: { error: "Target user not found" }, status: :not_found
      return
    end

    if @current_user.following?(target_user)
      @current_user.unfollow(target_user)
      render json: { message: "Unfollowed", following: false }, status: :ok
    else
      render json: { message: "Not following", following: false }, status: :ok
    end
  end

  # GET /api/v1/users/:user_id/followings
  def index
    followings = @current_user.following_users

    # Filtering by name if provided
    if params[:name].present?
      followings = followings.where("LOWER(name) LIKE ?", "%#{params[:name].downcase}%")
    end

    # Pagination
    page = params[:page].to_i > 0 ? params[:page].to_i : 1
    per_page = params[:per_page].to_i > 0 ? params[:per_page].to_i : 20
    followings = followings.offset((page - 1) * per_page).limit(per_page)

    render json: {
      followings: ::ActiveModelSerializers::SerializableResource.new(
        followings,
        each_serializer: UserSerializer
      ),
      pagination: {
        current_page: page,
        per_page: per_page,
        total_count: followings.count
      }
    }, status: :ok
  end
end

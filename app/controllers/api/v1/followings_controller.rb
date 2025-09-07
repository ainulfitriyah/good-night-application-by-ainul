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
end

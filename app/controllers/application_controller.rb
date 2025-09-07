class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def define_current_user
    @current_user = User.find_by(id: params[:user_id] || params[:id])
  end

  def authorize_user
    return if @current_user.present?

    render json: { error: "Unauthorized" }, status: :unauthorized
  end
end

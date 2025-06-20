class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :set_time_zone

  private

  def set_time_zone
    Time.zone = cookies[:timezone] if cookies[:timezone]
  end

  def current_user_has_time_zone?
    cookies[:timezone].present?
  end
end

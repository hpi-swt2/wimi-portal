class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  before_action :ensure_valid_email

  def ensure_valid_email
    unless current_user.nil?
      if current_user.email.blank? && ![destroy_user_session_path, profile_path].include?(request.env['PATH_INFO'])
        flash[:error] = 'Please set a valid email address first'
        redirect_to profile_path
      end
    end
  end
end

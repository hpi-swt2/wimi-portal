class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :ensure_valid_email, :set_locale

  before_filter :set_locale

  def ensure_valid_email
    requested_path = request.env['PATH_INFO']
    if current_user.nil?
      if requested_path != new_user_session_path && requested_path != superadmin_path
        flash[:error] = 'Please login first'
        redirect_to new_user_session_path
      end
    else
      has_invalid_email = (current_user.email == User::INVALID_EMAIL)
      allowed_paths = [destroy_user_session_path, edit_user_path(current_user), user_path(current_user)]
      visits_allowed_path = allowed_paths.include?(requested_path)
      if has_invalid_email && !visits_allowed_path
        flash[:error] = 'Please set a valid email address first'
        redirect_to edit_user_path(current_user)
      end
    end
  end

  private

  def set_locale
    if current_user
      if I18n.locale != current_user.language
        I18n.locale = current_user.language
      end
    else
      I18n.locale = I18n.default_locale
    end
  end
end

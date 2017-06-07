class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :ensure_valid_email, :set_locale

  before_filter :set_locale

  # Allow setting flash messages using 'success' and 'error' keywords in redirect_to calls
  # e.g. redirect_to root_path, success: 'Redirect success'
  # http://stackoverflow.com/questions/22566072/rails-4-flash-notice#32010436
  # add_flash_types :success, :error

  # Override the path that is redirected to after user is signed out.
  # This defaults to root_path.
  # https://github.com/plataformatec/devise/blob/master/lib/devise/controllers/helpers.rb
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  def ensure_valid_email
    requested_path = request.env['PATH_INFO']
    if current_user.nil?
      if requested_path != new_user_session_path && requested_path != external_login_path
        session[:previous_url] = request.fullpath
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

  def after_sign_in_path_for(resource)
    session[:previous_url] || root_path
  end
end

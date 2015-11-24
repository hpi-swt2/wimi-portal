class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  before_filter :set_locale

private
	def set_locale
      if (current_user)
	    I18n.locale = params[:locale] if params[:locale].present? || current_user.language
	    current_user.language = I18n.locale
	  else
	  	I18n.locale = I18n.default_locale
	  end	
	end

	def default_url_options(options = {})
		{locale: I18n.locale}
	end

end

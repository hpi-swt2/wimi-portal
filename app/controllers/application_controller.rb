class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  before_filter :set_locale

private
	def set_locale
      if current_user
      	if I18n.locale !=  current_user.language
	      I18n.locale =  current_user.language
	  	end
	  else
	  	I18n.locale = I18n.default_locale
	  end	
	end

	def default_url_options(options = {})
		{locale: I18n.locale}
	end

end

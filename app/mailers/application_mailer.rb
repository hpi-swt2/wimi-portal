class ApplicationMailer < ActionMailer::Base
  helper :application # gives access to all helpers defined within `application_helper`.
  include CanCan::ControllerAdditions

  def notification(event, user)
    @event = event
    @user = user
    # locale needs to be set manually, as the ApplicationMailer 
    # is not aware of the user's language settings
    subject = t('.subject', locale: user.language,
      text: t("event.user_friendly_name.#{@event.type}", locale: user.language)
    )
    # default from is configured in environments.
    mail(to: user.email, subject: subject)
  end

  private

  # Ensure that the function 'current_user' returns the user in the context
  # so that application helpers using cancan work, e.g. 'linked_name'
  def current_user
    @current_user
  end
end

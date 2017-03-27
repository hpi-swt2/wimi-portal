class MailNotifier < ApplicationMailer

  def notification(event, user)
    @event = event
    @user = user
    # locale needs to be set manually, as the ApplicationMailer 
    # is not aware of the user's language settings
    subject = t('mail_notifier.notification.subject', locale: user.language,
      text: t("event.user_friendly_name.#{@event.type}", locale: user.language)
    )
    mail(to: user.email, subject: subject)
  end

  private

  # Ensure that the function 'current_user' returns the user in the context
  # so that application helpers using cancan work, e.g. 'linked_name'
  def current_user
    @current_user
  end
end

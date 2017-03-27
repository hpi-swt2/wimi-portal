class MailNotifier < ApplicationMailer

  def notification(event, user)
    l = I18n.locale
    I18n.locale = user.language

    @greeting = t('mail_notifier.notification.hello') + user.name
    @event = event
    @current_user = user

    subject = t('mail_notifier.notification.subject', text: 
      t("event.user_friendly_name.#{@event.type}")
    )
    
    mail(to: user.email, subject: subject)
    I18n.locale = l
  end

  private

  # Ensure that the function 'current_user' returns the user in the context
  # so that application helpers using cancan work, e.g. 'linked_name'
  def current_user
    @current_user
  end
end

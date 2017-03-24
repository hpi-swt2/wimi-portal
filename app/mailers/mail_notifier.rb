class MailNotifier < ApplicationMailer
  default from: 'HPI Wimi Portal <hpi.wimiportal@gmail.com>'

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.mail_notifier.notification.subject
  #
  def notification(event, user)
    l = I18n.locale
    I18n.locale = user.language

    # i18n-tasks-use t'mail_notifier.notification.subject'
    @greeting = t('mail_notifier.notification.hello') + user.name
    @event = event
    @current_user = user

    mail to: user.email
    I18n.locale = l
  end

  private

  # Ensure that the function 'current_user' returns the user in the context
  # so that application helpers using cancan work, e.g. 'linked_name'
  def current_user
    @current_user
  end
end

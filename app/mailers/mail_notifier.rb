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

    @greeting = t('mail_notifier.notification.hello') + user.name
    @event = event
    # i18n-tasks-use t'mail_notifier.notification.subject'

    mail to: user.email
    I18n.locale = l
  end
end

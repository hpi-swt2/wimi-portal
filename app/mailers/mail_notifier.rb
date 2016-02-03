class MailNotifier < ApplicationMailer
  default from: 'HPI Wimi Portal <hpi.wimiportal@gmail.com>'

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.mail_notifier.invited.subject
  #
  def notification(event, user)
    @greeting = t('mail_notifier.notification.hello') + user.name
    @event = event

    mail to: "marcel@jankrift.de"
  end


end

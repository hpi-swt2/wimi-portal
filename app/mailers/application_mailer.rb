class ApplicationMailer < ActionMailer::Base
  helper :application # gives access to all helpers defined within `application_helper`.
  include CanCan::ControllerAdditions

  def notification(event, user)
    prepare_mail(event,user)
    # default from is configured in environments.
    mail(to: user.email, subject: @subject, content_type: 'text/html')
  end

  def notification_with_pdf(event, user, pdf, pdfname)
    prepare_mail(event,user)
    # default from is configured in environments.
    attachments[pdfname] = pdf
    mail(to: user.email, subject: @subject, template_name: "notification")
  end

  private

  def prepare_mail(event,user)
    @event = event
    @user = user
    # locale needs to be set manually, as the ApplicationMailer
    # is not aware of the user's language settings
    @subject = t('application_mailer.notification.subject', locale: user.language,
      text: t("event.user_friendly_name.#{@event.type}", locale: user.language))
  end
end

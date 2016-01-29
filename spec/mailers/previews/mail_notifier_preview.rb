# Preview all emails at http://localhost:3000/rails/mailers/mail_notifier
class MailNotifierPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/mail_notifier/invited
  def invited
    MailNotifier.invited
  end

  # Preview this email at http://localhost:3000/rails/mailers/mail_notifier/applied
  def applied
    MailNotifier.applied
  end

  # Preview this email at http://localhost:3000/rails/mailers/mail_notifier/requested
  def requested
    MailNotifier.requested
  end

end

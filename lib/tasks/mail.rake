# Rake task to test email sending capability.
# Run with 'bundle exec rake mail:smtp_test RAILS_ENV=production'
namespace :mail do
  desc "Test if ActionMailer can actually send an email with the current config"
  task smtp_test: :environment do
    abort("ERROR! Running in '#{Rails.env}' instead of 'production'") if !Rails.env.production?
    settings = ActionMailer::Base.smtp_settings
    Rails.application.configure do
      config.action_mailer.raise_delivery_errors = true
    end
    puts "Printing SMTP config..."
    puts settings
    if settings[:user_name].blank? or settings[:password].blank?
      abort('ERROR! user name or password not set!')
    end
    puts "Enter E-Mail address to send to:"
    email = get_input
    from = settings[:user_name] + settings[:domain]
    puts "Attempting to send email to '#{email}' from '#{from}'..."
    subject = "#{settings[:user_name]} email delivery test"
    body = "Test email from #{from}, sent at #{Time.now}"
    ActionMailer::Base.mail(from: from, to: email, subject: subject, body: body).deliver_now
    puts ""
    puts "Done. Please check if the email arrived"
    Rails.application.configure do
      config.action_mailer.raise_delivery_errors = false
    end
  end
end

def get_input
  STDOUT.flush
  return STDIN.gets.chomp
end
require 'factory_bot_rails'

# Rake task to test email sending capability.
# Run with 'bundle exec rake mail:smtp_test RAILS_ENV=production'
namespace :mail do
  desc "Test if ActionMailer::Base can actually send an email with the current config"
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
    ActionMailer::Base.mail(to: email, subject: subject, body: body).deliver_now
    puts ""
    puts "Done. Please check if the email arrived"
    Rails.application.configure do
      config.action_mailer.raise_delivery_errors = false
    end
  end

  desc "Test if ApplicationMailer::notification sends an email"
  task notification_test: :environment do
    Rails.application.configure do
      config.action_mailer.raise_delivery_errors = true
    end
    puts "Enter E-Mail address to send to:"
    email = get_input
    user = User.new(first_name: 'first', last_name: 'last', email: email)
    event = Event.new(type: 'project_create', user: user, object: Project.first, target_user: user, created_at: Time.now)
    puts "Attempting to send email to '#{user.email}'..."
    ApplicationMailer.notification(event, user).deliver_now
    puts ""
    puts "Done. Please check if the email arrived"
    Rails.application.configure do
      config.action_mailer.raise_delivery_errors = false
    end
  end

  desc "Test if adding an event sends an email to those who opted in"
  task event_test: :environment do
    begin
      Rails.application.configure do
        config.action_mailer.raise_delivery_errors = true
      end
      puts "Enter E-Mail address to send to:"
      email = get_input
      wimi = FactoryBot.create(:user, email: 'a@example.com')
      chair = FactoryBot.create(:chair, representative: wimi)
      hiwi = FactoryBot.create(:user, email: email)
      project = FactoryBot.create(:project, chair: chair)
      puts "Attempting to send email to '#{hiwi.email}'..."
      Event.add('project_join', wimi, project, hiwi)
      puts ""
      puts "Done. Please check if the email arrived"
      Rails.application.configure do
        config.action_mailer.raise_delivery_errors = false
      end
    ensure
      project.destroy if project
      hiwi.destroy if hiwi
      wimi.destroy if wimi
      chair.destroy if chair
    end
  end
end

def get_input
  STDOUT.flush
  return STDIN.gets.chomp
end

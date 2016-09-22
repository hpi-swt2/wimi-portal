namespace :mail do
  desc "Test if ActionMailer can actually send an email with the current config"
  task smtp_test: :environment do
  	puts "Printing SMTP config..."
  	puts ActionMailer::Base.smtp_settings
  	puts "Attempting to send email..."
	ActionMailer::Base.mail(from: "test@example.com", to: "test@example.com", subject: "Test", body: "Test").deliver_now
  	puts "Done"
  end
end

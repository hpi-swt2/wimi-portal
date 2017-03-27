require "rails_helper"

RSpec.describe MailNotifier, type: :mailer do
  describe "notification" do

    let(:user) { FactoryGirl.create(:user) }
    let(:event) { FactoryGirl.create(:event, user: user, target_user: user) }
    let(:mail) { MailNotifier.notification(event, user) }

    it "renders the headers" do
      expect(mail.subject).to eq(I18n.t("mail_notifier.notification.subject"))
      expect(mail.to.count).to eq(1)
      expect(mail.to.first).to eq(user.email)
      expect(mail.from.count).to eq(1)
      # Default from has the form '{display_name} <{email_address}>'
      expect(MailNotifier.default[:from]).to include(mail.from.first)
    end

    it "renders the body" do
      expect(mail.body.encoded).to match(I18n.t("mail_notifier.notification.hello"))
    end

    it "finds name of user in email" do
      expect(mail.body.encoded).to match(user.name)
    end
  end

end

require "rails_helper"

RSpec.describe ApplicationMailer, type: :mailer do
  let(:user) { FactoryGirl.create(:user) }
  
  describe "notification" do
    let(:event) { FactoryGirl.create(:event, user: user, target_user: user) }
    let(:mail) { ApplicationMailer.notification(event, user) }

    it "renders the headers" do
      subj = I18n.t("application_mailer.notification.subject",
        text: I18n.t("event.user_friendly_name.#{event.type}")
      )
      expect(mail.subject).to eq(subj)
      expect(mail.to.count).to eq(1)
      expect(mail.to.first).to eq(user.email)
      expect(mail.from.count).to eq(1)
      # Default from has the form '{display_name} <{email_address}>'
      expect(ApplicationMailer.default[:from]).to include(mail.from.first)
    end

    it "renders the body" do
      expect(mail.body.encoded).to match(I18n.t("application_mailer.notification.hello", name: user.first_name))
    end

    it "finds name of user in email" do
      expect(mail.body.encoded).to match(user.name)
    end
  end

  describe "notification" do
    let(:event) { FactoryGirl.create(:event, user: user, target_user: user, type: 'time_sheet_closed') }
    let(:mail) { ApplicationMailer.notification(event, user) }
    
    it "renders extended message" do
      expect(mail.body.encoded).to match(I18n.t("event.extended_message.time_sheet_closed"))
    end

  end

end

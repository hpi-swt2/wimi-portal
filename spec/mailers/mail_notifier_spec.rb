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

    it "renders a greeting in the body" do
      expect(mail.body.encoded).to match(I18n.t("application_mailer.notification.hello", name: user.first_name))
    end

    it "renders the name of the user in the body of the email" do
      expect(mail.body.encoded).to match(user.name)
    end

    context "extended message" do
      let(:event) { FactoryGirl.create(:event, user: user, target_user: user) }
      let(:mail) { ApplicationMailer.notification(event, user) }
      let(:time_sheet_closed_event) { FactoryGirl.create(:event, user: user, target_user: user, type: 'time_sheet_closed') }
      let(:closed_mail) { ApplicationMailer.notification(time_sheet_closed_event, user) }
      
      it "is rendered for time_sheet_closed events" do
        expect(closed_mail.body.encoded).to match(I18n.t("event.extended_message.time_sheet_closed"))
      end

      it "is not rendered for for other events" do
        expect(mail.body.encoded).to_not match(I18n.t("event.extended_message.time_sheet_closed"))
      end
    end

  end
end

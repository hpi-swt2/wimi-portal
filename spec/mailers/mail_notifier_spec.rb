require "rails_helper"

RSpec.describe ApplicationMailer, type: :mailer do
  let(:user) { FactoryGirl.create(:user) }
  
  describe "notification project_create" do
    let(:event) { FactoryGirl.create(:event, type: 'project_create', object: FactoryGirl.create(:project), user: user, target_user: user) }
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

    it "renders links to the concerned entities" do
      expect(mail.body.encoded).to have_selector(:linkhref, user_url(user))
    end
  end

  describe "extended notification messages" do
    it "is rendered for time_sheet_closed events" do
      time_sheet_closed_event = FactoryGirl.create(:event, user: user, target_user: user, type: 'time_sheet_closed')
      closed_mail = ApplicationMailer.notification(time_sheet_closed_event, user)
      expect(closed_mail.body.encoded).to match(I18n.t("event.extended_message.time_sheet_closed"))
    end

    it "is not rendered for project_create" do
      event = FactoryGirl.create(:event, type: 'project_create', object: FactoryGirl.create(:project), user: user, target_user: user)
      mail = ApplicationMailer.notification(event, user)
      expect(mail.body.encoded).to_not match(I18n.t("event.extended_message.time_sheet_closed"))
    end
  end

  describe "notification time_sheet_hand_in" do
    let(:hiwi) { FactoryGirl.create(:hiwi) }
    let(:wimi) { FactoryGirl.create(:wimi).user }
    let(:contract) { FactoryGirl.create(:contract, hiwi: @hiwi, responsible: @wimi) }
    let(:time_sheet) { FactoryGirl.create(:time_sheet, contract: @contract, handed_in: true, status: 'pending') }
    let(:event) { FactoryGirl.create(:event, type: 'time_sheet_hand_in', object: time_sheet, user: hiwi, target_user: wimi) }
    let(:mail) { ApplicationMailer.notification(event, hiwi) }

    it "renders a greeting in the body" do
      expect(mail.body.encoded).to match(I18n.t("application_mailer.notification.hello", name: hiwi.first_name))
    end
  end
end

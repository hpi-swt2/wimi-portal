require "rails_helper"

RSpec.describe ApplicationMailer, type: :mailer do
  let(:user) { FactoryBot.create(:wimi).user }
  
  describe "notification project_create" do
    let(:project) { FactoryBot.create(:project, chair: user.chair) }
    let(:event) { FactoryBot.create(:event, type: 'project_create', object: project, user: user, target_user: user) }
    let(:mail) { ApplicationMailer.notification(event, user) }

    it "renders the headers" do
      expect(mail.subject).to match(I18n.t("event.user_friendly_name.#{event.type}"))
      expect(mail.to.count).to eq(1)
      expect(mail.to.first).to eq(user.email)
      expect(mail.from.count).to eq(1)
      # Default from has the form '{display_name} <{email_address}>'
      expect(ApplicationMailer.default[:from]).to include(mail.from.first)
    end

    it "renders a greeting in the body" do
      expect(mail.body.encoded).to match(I18n.t("application_mailer.notification.hello", name: user.first_name))
    end

    it "renders the name of the user as part of the message" do
      expect(mail.body.encoded).to match(user.name)
    end

    it "renders links to the concerned entities" do
      expect(mail.body.encoded).to have_selector(:linkhref, user_url(user), count: 1)
      expect(mail.body.encoded).to have_selector(:linkhref, project_url(event.object), count: 1)
    end

    it "renders a link to User#edit to change notification settings " do
      expect(mail.body.encoded).to have_selector(:linkhref, edit_user_url(user), count: 1)
    end

    it "has content type text/html" do
      expect(mail.content_type).to match("text/html")
    end
  end

  describe "extended notification messages" do
    it "is rendered for time_sheet_closed events" do
      time_sheet_closed_event = FactoryBot.create(:event, user: user, target_user: user, type: 'time_sheet_closed')
      closed_mail = ApplicationMailer.notification(time_sheet_closed_event, user)
      expect(closed_mail.body.encoded).to match(I18n.t("event.extended_message.time_sheet_closed"))
    end

    it "is not rendered for project_create" do
      event = FactoryBot.create(:event, type: 'project_create', object: FactoryBot.create(:project), user: user, target_user: user)
      mail = ApplicationMailer.notification(event, user)
      expect(mail.body.encoded).to_not match(I18n.t("event.extended_message.time_sheet_closed"))
    end
  end

  describe "notification time_sheet_hand_in" do
    let(:hiwi) { FactoryBot.create(:hiwi) }
    let(:wimi) { FactoryBot.create(:wimi).user }
    let(:contract) { FactoryBot.create(:contract, hiwi: hiwi, responsible: wimi) }
    let(:time_sheet) { FactoryBot.create(:time_sheet, contract: contract, handed_in: true, status: 'pending') }
    let(:event) { FactoryBot.create(:event, type: 'time_sheet_hand_in', object: time_sheet, user: hiwi, target_user: wimi) }
    let(:mail) { ApplicationMailer.notification(event, hiwi) }

    it "renders links to the concerned entities" do
      expect(mail.body.encoded).to have_selector(:linkhref, user_url(hiwi), count: 1)
      expect(mail.body.encoded).to have_selector(:linkhref, user_url(wimi), count: 1)
      expect(mail.body.encoded).to have_selector(:linkhref, time_sheet_url(time_sheet), count: 1)
    end
  end

  describe "notification time_sheet_accept" do
    let(:hiwi) { FactoryBot.create(:hiwi) }
    let(:wimi) { FactoryBot.create(:wimi).user }
    let(:contract) { FactoryBot.create(:contract, hiwi: hiwi, responsible: wimi) }
    let(:time_sheet) { FactoryBot.create(:time_sheet, contract: contract, handed_in: true, status: 'accepted') }
    let(:event) { FactoryBot.create(:event, type: 'time_sheet_accept', object: time_sheet, user: hiwi, target_user: wimi) }
    let(:mail) { ApplicationMailer.notification_with_pdf(event, hiwi, time_sheet.make_attachment, "test.pdf") }

    it "has content type multipart/mixed" do
      expect(mail.content_type).to match("multipart/mixed")
    end
  end
end

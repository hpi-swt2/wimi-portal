require "rails_helper"

RSpec.describe MailNotifier, type: :mailer do
  describe "invited" do
    let(:mail) { MailNotifier.invited }

    it "renders the headers" do
      expect(mail.subject).to eq("Invited")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "applied" do
    let(:mail) { MailNotifier.applied }

    it "renders the headers" do
      expect(mail.subject).to eq("Applied")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "requested" do
    let(:mail) { MailNotifier.requested }

    it "renders the headers" do
      expect(mail.subject).to eq("Requested")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end

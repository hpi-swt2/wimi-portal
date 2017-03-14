require "rails_helper"

RSpec.describe MailNotifier, type: :mailer do
  describe "notification" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @event = FactoryGirl.create(:event, user: @user, target_user: @user)
    end
    let(:mail) { MailNotifier.notification(@event, @user) }

    it "renders the headers" do
      expect(mail.subject).to eq("You received a new notification")
      expect(mail.to).to eq([@user.email])
      expect(mail.from).to eq(["hpi.wimiportal@gmail.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match('Hello')
    end

    it "finds name of user in email" do
      expect(mail.body.encoded).to match(@user.name)
    end
  end

end

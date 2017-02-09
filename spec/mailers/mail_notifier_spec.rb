require "rails_helper"

RSpec.describe MailNotifier, type: :mailer do
  describe "notification" do
    before(:each) do
      pending 'rewrite event system'
      @user = FactoryGirl.create(:user)
      @event = FactoryGirl.create(:event_admin_right, trigger: @user, target: @user, status: 'added')
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

# == Schema Information
#
# Table name: events
#
#  id         :integer          not null, primary key
#  trigger_id :integer
#  target_id  :integer
#  chair_id   :integer
#  seclevel   :integer
#  type       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  status     :string
#
require 'rails_helper'

RSpec.describe EventTimeSheetSubmitted, type: :feature do
  describe 'sending an email to the responsible wimi after timesheet submission.' do
    before(:each) do
      @chair = FactoryGirl.create(:chair)
      @employee = FactoryGirl.create(:user)
      @responsible = FactoryGirl.create(:user, email_notification: true)
      FactoryGirl.create(:wimi, chair: @chair, user: @responsible)
      @contract = FactoryGirl.create(:contract, hiwi: @employee, responsible: @responsible)
      @timesheet = FactoryGirl.create(:time_sheet, user: @employee, chair: @chair, contract: @contract)
    end

    after(:each) do
      ActionMailer::Base.deliveries.clear
    end

    it 'creates a new EventTimeSheetSubmitted instance, when calling "instrument" with correct type' do
      expect {
        ActiveSupport::Notifications.instrument('event', trigger: @timesheet.id, target: @responsible.id, seclevel: :wimi, type: 'EventTimeSheetSubmitted')
      }.to change { EventTimeSheetSubmitted.count }.by(1)
    end

    it 'sends email if notifications are turned on' do
      event = EventTimeSheetSubmitted.new(trigger_id: @timesheet.id, target_id: @responsible.id, chair_id: @chair.id, seclevel: :wimi)
      expect(event).to be_valid
      expect { event.save }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end

    it 'does not send email if notifications are turned off' do
      @responsible.update(email_notification: false)
      event = EventTimeSheetSubmitted.new(trigger_id: @timesheet.id, target_id: @responsible.id, chair_id: @chair.id, seclevel: :wimi)
      expect { event.save }.to change { ActionMailer::Base.deliveries.count }.by(0)
    end

    it 'sends email to the responsible wimi' do
      event = EventTimeSheetSubmitted.create(trigger_id: @timesheet.id, target_id: @responsible.id, chair_id: @chair.id, seclevel: :wimi)
      expect(ActionMailer::Base.deliveries.first.to.first).to eq @responsible.email
    end

    it 'sends an email to a single recipient' do
      event = EventTimeSheetSubmitted.create(trigger_id: @timesheet.id, target_id: @responsible.id, chair_id: @chair.id, seclevel: :wimi)
      expect(ActionMailer::Base.deliveries.first.to.count).to eq 1
    end

    it 'mentions the name of the recipient in the body' do
      event = EventTimeSheetSubmitted.create(trigger_id: @timesheet.id, target_id: @responsible.id, chair_id: @chair.id, seclevel: :wimi)
      expect(ActionMailer::Base.deliveries.first.body.encoded).to match(@responsible.first_name)
    end

    it 'mentions the name of the hiwi in the body' do
      event = EventTimeSheetSubmitted.create(trigger_id: @timesheet.id, target_id: @responsible.id, chair_id: @chair.id, seclevel: :wimi)
      expect(ActionMailer::Base.deliveries.first.body.encoded).to match(@employee.name)
    end

    it 'includes a link to the timesheet' do
      event = EventTimeSheetSubmitted.create(trigger_id: @timesheet.id, target_id: @responsible.id, chair_id: @chair.id, seclevel: :wimi)
      work_day_index_path = time_sheet_path(@timesheet)
      expect(ActionMailer::Base.deliveries.first.body.encoded).to match(work_day_index_path)
    end
  end
end

# == Schema Information
#
# Table name: time_sheets
#
#  id                       :integer          not null, primary key
#  month                    :integer
#  year                     :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  handed_in                :boolean          default(FALSE)
#  rejection_message        :text             default("")
#  signed                   :boolean          default(FALSE)
#  last_modified            :date
#  status                   :integer          default(0)
#  signer                   :integer
#  wimi_signed              :boolean          default(FALSE)
#  hand_in_date             :date
#  user_signature           :text
#  representative_signature :text
#  user_signed_at           :date
#  representative_signed_at :date
#  contract_id              :integer          not null
#

require 'rails_helper'

RSpec.describe TimeSheet, type: :model do
  before(:each) do
    @sheet = FactoryGirl.create(:time_sheet)
    @user = @sheet.user
    @project = FactoryGirl.create(:project)
    @user.projects << @project
  end

  it 'sums up the right ammount of working hours' do
    time1 = Time.parse('10:00:00')
    time2 = Time.parse('11:00:00')
    time3 = Time.parse('12:00:00')
    FactoryGirl.create(:work_day, start_time: time1, end_time: time2, user: @user, project: @project)
    FactoryGirl.create(:work_day, start_time: time2, end_time: time3, user: @user, project: @project)
    
    expect(@sheet.sum_hours).to eq(2)
  end
end

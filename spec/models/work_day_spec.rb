# == Schema Information
#
# Table name: work_days
#
#  id         :integer          not null, primary key
#  date       :date
#  start_time :time
#  break      :integer
#  end_time   :time
#  attendance :string
#  notes      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#  project_id :integer
#

require 'rails_helper'
require 'spec_helper'

describe WorkDay, type: :model do

  let(:start_time) { Time.now.at_middle_of_day }
  let(:end_time) { Time.now.at_middle_of_day + 2.hours }
  
  it 'returns the duration of a work_day' do
    workday = FactoryGirl.create(:work_day, start_time: start_time, end_time: end_time, break: 30)
    expect(workday.duration).to eq(1.5)
  end

  it 'is invalid when times overlap' do
    @user = FactoryGirl.create(:user)
    @project = FactoryGirl.create(:project)
    time1 = Time.parse('10:00:00')
    time2 = Time.parse('11:00:00')
    time3 = Time.parse('12:00:00')
    time4 = Time.parse('13:00:00')
    FactoryGirl.create(:work_day, start_time: time1, end_time: time3, break: 0, user: @user, project: @project)
    expect(FactoryGirl.build(:work_day, start_time: time2, end_time: time4, break: 0, user: @user, project: @project)).to_not be_valid
  end
end

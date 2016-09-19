# == Schema Information
#
# Table name: work_days
#
#  id            :integer          not null, primary key
#  date          :date
#  start_time    :time
#  break         :integer
#  end_time      :time
#  notes         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  time_sheet_id :integer
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

  # date is not chosen by user anymore, times cannot overlap

  # it 'is invalid when times overlap' do
  #   contract = FactoryGirl.create(:contract, hiwi: user)
  #   project = FactoryGirl.create(:project)
  #   FactoryGirl.create(:work_day,
  #     date: Date.today,
  #     start_time: '2000-01-01 10:00:00',
  #     end_time: '2000-01-01 15:00:00',
  #     project: project)
  #   overlapping = FactoryGirl.build(:work_day,
  #     date: Date.today,
  #     start_time: '2000-01-01 12:00:00',
  #     end_time: '2000-01-01 17:00:00',
  #     project: project)
  #   expect(overlapping).to_not be_valid
  # end

  it 'requires a project to be related to' do
    workday = FactoryGirl.build(:work_day, project: nil)
    expect(workday).to be_invalid
  end
end

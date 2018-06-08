# == Schema Information
#
# Table name: projects
#
#  id             :integer          not null, primary key
#  title          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  description    :string           default("")
#  status         :boolean          default(TRUE)
#  chair_id       :integer
#  project_leader :string           default("")
#

require 'rails_helper'

RSpec.describe Project, type: :model do
  before(:each) do
    @project = FactoryGirl.create(:project)
    @project.users << FactoryGirl.build_stubbed(:user)
    @project.users << FactoryGirl.build_stubbed(:user)
    @project.users << FactoryGirl.build_stubbed(:wimi, chair_id: @project.chair.id).user
    @project.users << FactoryGirl.build_stubbed(:wimi, chair_id: @project.chair.id).user
  end

  it 'can return all wimis in an unique array' do
    chair = FactoryGirl.build_stubbed(:chair)
    project = FactoryGirl.create(:project)
    user1 = FactoryGirl.build_stubbed(:user)
    user2 = FactoryGirl.build_stubbed(:user)
    user3 = FactoryGirl.build_stubbed(:user)
    chair_wimi1 = FactoryGirl.build_stubbed(:wimi, application: 'accepted', user: user1, chair: chair)
    chair_wimi2 = FactoryGirl.build_stubbed(:wimi, application: 'accepted', user: user2, chair: chair)
    project.users << user1
    project.users << user2
    project.users << user3

    expect(project.wimis).to eq [user1, user2]
  end

  it 'has a valid factory' do
    expect(FactoryGirl.create(:project)).to be_valid
  end

  it 'lists all wimis of a project' do
    expect(@project.wimis.size).to eq(2)
  end

  it 'lists all hiwis of a project' do
    expect(@project.hiwis.size).to eq(2)
  end

  # same test as in the controller ?
  
  # it 'returns the sum of all working hours the hiwis did per month' do
  #   chair = FactoryGirl.create(:chair)
  #   project = FactoryGirl.create(:project)
  #   user1 = FactoryGirl.create(:user)
  #   FactoryGirl.create(:contract, hiwi: user1, end_date: Date.today.beginning_of_month + 2.months)
  #   user2 = FactoryGirl.create(:user)
  #   FactoryGirl.create(:contract, hiwi: user2)
  #   project.users << user1
  #   project.users << user2

  #   FactoryGirl.create(:work_day,
  #     date: Date.today.beginning_of_month + 2.days,
  #     start_time: '2000-01-01 15:00:00',
  #     break: 30,
  #     end_time: '2000-01-01 16:00:00',
  #     user: user1,
  #     project: project)
  #   FactoryGirl.create(:work_day,
  #     date: Date.today.beginning_of_month + 1.week,
  #     start_time: '2000-01-01 10:00:00',
  #     break: 0,
  #     end_time: '2000-01-01 18:00:00',
  #     user: user2,
  #     project: project)
  #   FactoryGirl.create(:work_day,
  #     date: Date.today.beginning_of_month.next_month,
  #     start_time: '2015-12-25 10:00:00',
  #     break: 0,
  #     end_time: '2015-11-26 18:00:00',
  #     user: user1,
  #     project: project)

  #   expect(project.hiwi_working_hours_for(Date.today.year, Date.today.month)).to eq 8.5
  #   expect(project.hiwi_working_hours_for(Date.today.year, Date.today.next_month.month)).to eq 8
  # end

  # TODO: move to projects controller
#  it 'returns correct data for ChartJS' do
#    chair = FactoryGirl.create(:chair)
#    project = FactoryGirl.create(:project, title: 'Working Hours Project')
#    user1 = FactoryGirl.create(:user)
#    user2 = FactoryGirl.create(:user)
#    project.users << user1
#    project.users << user2
#
#    FactoryGirl.create(:work_day, date: '2015-11-18', start_time: '2015-11-18 15:11:53', break: 30, end_time: '2015-11-18 16:11:53', user: user1, project: project)
#    FactoryGirl.create(:work_day, date: '2015-12-25', start_time: '2015-12-25 10:00:00', break: 0, end_time: '2015-11-26 18:00:00', user: user1, project: project)
#
#    FactoryGirl.create(:work_day, date: '2015-11-26', start_time: '2015-11-26 10:00:00', break: 0, end_time: '2015-11-26 18:00:00', user: user2, project: project)
#
#    expect(Project.working_hours_data(2015, 10)).to eq("[{\"y\":0,\"name\":\"Factory Project\"},{\"y\":0,\"name\":\"Working Hours Project\"}]")
#    expect(Project.working_hours_data(2015, 11)).to eq("[{\"y\":0,\"name\":\"Factory Project\"},{\"y\":8.5,\"name\":\"Working Hours Project\"}]")
#    expect(Project.working_hours_data(2015, 12)).to eq("[{\"y\":0,\"name\":\"Factory Project\"},{\"y\":8.0,\"name\":\"Working Hours Project\"}]"
#)
#  end
end

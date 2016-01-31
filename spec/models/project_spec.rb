# == Schema Information
#
# Table name: projects
#
#  id             :integer          not null, primary key
#  title          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  description    :string           default("")
#  public         :boolean          default(TRUE)
#  status         :boolean          default(TRUE)
#  chair_id       :integer
#  project_leader :string           default("")
#

require 'rails_helper'

RSpec.describe Project, type: :model do
  before(:each) do
    @project = FactoryGirl.create(:project)
    @project.users << FactoryGirl.create(:user)
    @project.users << FactoryGirl.create(:user)
    @project.users << FactoryGirl.create(:wimi, chair_id: @project.chair.id).user
    @project.users << FactoryGirl.create(:wimi, chair_id: @project.chair.id).user
  end

  it 'can return all wimis in an unique array' do
    chair = FactoryGirl.create(:chair)
    project = FactoryGirl.create(:project)
    user1 = FactoryGirl.create(:user)
    user2 = FactoryGirl.create(:user)
    user3 = FactoryGirl.create(:user)
    chair_wimi1 = FactoryGirl.create(:wimi, application: 'accepted', user: user1, chair: chair)
    chair_wimi2 = FactoryGirl.create(:wimi, application: 'accepted', user: user2, chair: chair)
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

  it 'returns the sum of all working hours the hiwis did per month' do
    chair = FactoryGirl.create(:chair)
    project = FactoryGirl.create(:project)
    user1 = FactoryGirl.create(:user)
    user2 = FactoryGirl.create(:user)
    project.users << user1
    project.users << user2

    FactoryGirl.create(:work_day, date: '2015-11-18', start_time: '2015-11-18 15:11:53', break: 30, end_time: '2015-11-18 16:11:53', user: user1, project: project)
    FactoryGirl.create(:work_day, date: '2015-11-26', start_time: '2015-11-26 10:00:00', break: 0, end_time: '2015-11-26 18:00:00', user: user2, project: project)
    FactoryGirl.create(:work_day, date: '2015-12-25', start_time: '2015-12-25 10:00:00', break: 0, end_time: '2015-11-26 18:00:00', user: user1, project: project)

    expect(project.hiwi_workdays_for(2015, 11)).to eq 8.5
    expect(project.hiwi_workdays_for(2015, 12)).to eq 8
  end

  it 'returns correct data for ChartJS' do
    chair = FactoryGirl.create(:chair)
    project = FactoryGirl.create(:project, title: 'Working Hours Project')
    user1 = FactoryGirl.create(:user)
    user2 = FactoryGirl.create(:user)
    project.users << user1
    project.users << user2

    FactoryGirl.create(:work_day, date: '2015-11-18', start_time: '2015-11-18 15:11:53', break: 30, end_time: '2015-11-18 16:11:53', user: user1, project: project)
    FactoryGirl.create(:work_day, date: '2015-12-25', start_time: '2015-12-25 10:00:00', break: 0, end_time: '2015-11-26 18:00:00', user: user1, project: project)

    FactoryGirl.create(:work_day, date: '2015-11-26', start_time: '2015-11-26 10:00:00', break: 0, end_time: '2015-11-26 18:00:00', user: user2, project: project)

    expect(Project.workdays_data(2015, 11)).to eq( "[{\"y\":0,\"name\":\"Factory Project\"},{\"y\":8.5,\"name\":\"Working Hours Project\"}]")
    expect(Project.workdays_data(2015, 12)).to eq( "[{\"y\":0,\"name\":\"Factory Project\"},{\"y\":8.0,\"name\":\"Working Hours Project\"}]"
)
  end
end

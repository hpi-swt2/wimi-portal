require 'rails_helper'

RSpec.describe 'work_days/index.html.erb', type: :view do
  before :each do
    @user = FactoryGirl.create(:user)
    @chair = FactoryGirl.create(:chair)
    ChairWimi.create(user: @user, chair: @chair, representative: true)
    login_as(@user, scope: :user)
    @project = FactoryGirl.create(:project)
    @project.add_user(@user)
  end

  it 'expects a hand in button for not handed in timesheets' do
    FactoryGirl.create(:time_sheet, user: @user, project: @project, handed_in: false)
    visit work_days_path(month: Date.today.month, year: Date.today.year, project: @project.id, user_id: @user.id)
    expect(page).to have_selector("input[type=submit][value= 'hand in']")
  end

  it 'expects a accept button for handed in timesheets' do
    FactoryGirl.create(:time_sheet, user: @user, project: @project, handed_in: true)
    visit work_days_path(month: Date.today.month, year: Date.today.year, project: @project.id, user_id: @user.id)
    expect(page).to have_selector('input[type=submit][value= accept]')
  end

  it 'expects a reject button for handed in timesheets' do
    FactoryGirl.create(:time_sheet, user_id: @user.id, project_id: @project.id, handed_in: true)
    visit work_days_path(month: Date.today.month, year: Date.today.year, project: @project.id, user_id: @user.id)
    expect(page).to have_selector('input[type=submit][value= reject]')
  end

  it 'rejects a TimeSheet if reject button is pressed' do
    timesheet = FactoryGirl.create(:time_sheet, user: @user, project: @project, handed_in: true)
    visit work_days_path(month: Date.today.month, year: Date.today.year, project: @project.id, user_id: @user.id)
    click_on('reject')
    timesheet.reload
    expect(timesheet.status).eql? 'rejected'
  end

  it 'accepts a TimeSheet if accept button is pressed' do
    timesheet = FactoryGirl.create(:time_sheet, user: @user, project: @project, handed_in: true)
    visit work_days_path(month: Date.today.month, year: Date.today.year, project: @project.id, user_id: @user.id)
    click_on('accept')
    timesheet.reload
    expect(timesheet.status).eql? 'accepted'
  end

  it 'hands in a TimeSheet if hand in button is pressed' do
    timesheet = FactoryGirl.create(:time_sheet, user: @user, project: @project, handed_in: false)
    visit work_days_path(month: Date.today.month, year: Date.today.year, project: @project.id, user_id: @user.id)
    click_on('hand in')
    timesheet.reload
    expect(timesheet.handed_in).to be true
  end

  it 're hands in a TimeSheet if sign button is pressed' do
    timesheet = FactoryGirl.create(:time_sheet, user: @user, project: @project, handed_in: false, status: 'rejected', signer: @user.id)
    visit work_days_path(month: Date.today.month, year: Date.today.year, project: @project.id, user_id: @user.id)
    click_on('hand in')
    timesheet.reload
    expect(timesheet.status).eql? ('rejected')
  end

  it 'denies the superadmin to access the work days page' do
    superadmin = FactoryGirl.create(:user, superadmin: true)
    login_as superadmin
    visit work_days_path
    expect(current_path).to eq(dashboard_path)
  end
end

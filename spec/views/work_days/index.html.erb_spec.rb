require 'rails_helper'	

RSpec.describe "work_days/index.html.erb", type: :view do
  before :each do
  	@superadmin = FactoryGirl.create(:user, superadmin: true)
    @chair = FactoryGirl.create(:chair)
    ChairWimi.create(user: @superadmin, chair: @chair, representative: true)
    login_as(@superadmin, scope: :user)
    @project = FactoryGirl.create(:project)
  end

  it 'expects a sign-button for not handed in timesheets' do
    FactoryGirl.create(:time_sheet, user_id: @superadmin.id, project_id: @project.id, handed_in: false)
	  visit work_days_path(month: Date.today.month, year: Date.today.year, project: @project.id, user_id: @superadmin.id)
	  expect(page).to have_selector("input[type=submit][value='sign']")
  end

  it 'expects a sign-button for handed in timesheets' do
    FactoryGirl.create(:time_sheet, user_id: @superadmin.id, project_id: @project.id, handed_in: true)
	  visit work_days_path(month: Date.today.month, year: Date.today.year, project: @project.id, user_id: @superadmin.id)
	  expect(page).to have_selector("input[type=submit][value='sign']")
  end

  it 'expects a reject-button for handed in timesheets' do
    FactoryGirl.create(:time_sheet, user_id: @superadmin.id, project_id: @project.id, handed_in: true)
	  visit work_days_path(month: Date.today.month, year: Date.today.year, project: @project.id, user_id: @superadmin.id)
	  expect(page).to have_selector("input[type=submit][value='reject']")
  end

  it 'rejects a TimeSheet if reject button is pressed' do
    timesheet = FactoryGirl.create(:time_sheet, user_id: @superadmin.id, project_id: @project.id, handed_in: true)
    visit work_days_path(month: Date.today.month, year: Date.today.year, project: @project.id, user_id: @superadmin.id)
    page.find("input[type=submit][value='reject']").click
    timesheet.reload
    expect(timesheet.status).eql? 'rejected'
  end

  it 'accepts a TimeSheet if sign button is pressed' do
    timesheet = FactoryGirl.create(:time_sheet, user_id: @superadmin.id, project_id: @project.id, handed_in: true)
    visit work_days_path(month: Date.today.month, year: Date.today.year, project: @project.id, user_id: @superadmin.id)
    page.find("input[type=submit][value='sign']").click
    timesheet.reload
    expect(timesheet.status).eql? 'accepted'
  end

  it 'hands in a TimeSheet if sign button is pressed' do
    timesheet = FactoryGirl.create(:time_sheet, user_id: @superadmin.id, project_id: @project.id, handed_in: false)
    visit work_days_path(month: Date.today.month, year: Date.today.year, project: @project.id, user_id: @superadmin.id)
    page.find("input[type=submit][value='sign']").click
    timesheet.reload
    expect(timesheet.handed_in).to be true
  end

  it 're hands in a TimeSheet if sign button is pressed' do
    timesheet = FactoryGirl.create(:time_sheet, user_id: @superadmin.id, project_id: @project.id, handed_in: false, status: 'rejected', signer: @superadmin.id)
    visit work_days_path(month: Date.today.month, year: Date.today.year, project: @project.id, user_id: @superadmin.id)
    page.find("input[type=submit][value='sign']").click
    timesheet.reload
    expect(timesheet.status).eql? ('rejected')
  end
end
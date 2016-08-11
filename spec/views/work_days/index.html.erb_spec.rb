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
    contract = FactoryGirl.create(:time_sheet, user: @user, chair: @chair).contract
    visit work_days_path(month: Date.today.month, year: Date.today.year, contract: contract)
    expect(page).to have_selector("input[type=submit][value= 'hand in']")
  end

  it 'expects a accept button for handed in timesheets' do
    contract = FactoryGirl.create(:time_sheet, user: @user, chair: @chair, handed_in: true).contract
    visit work_days_path(month: Date.today.month, year: Date.today.year, contract: contract)
    expect(page).to have_selector('input[type=submit][value= accept]')
  end

  it 'expects a reject button for handed in timesheets' do
    contract = FactoryGirl.create(:time_sheet, user: @user, chair: @chair, handed_in: true).contract
    visit work_days_path(month: Date.today.month, year: Date.today.year, contract: contract)
    expect(page).to have_selector('input[type=submit][value= reject]')
  end
  
  it 'does not show work days of other hiwis' do
    @hiwi1 = FactoryGirl.create(:contract, chair: @chair).hiwi
    @hiwi2 = FactoryGirl.create(:contract, chair: @chair).hiwi
    d1 = Date.today.at_beginning_of_month
    d2 = d1 + 1.day
    FactoryGirl.create(:work_day, user: @hiwi1, date: d1)
    FactoryGirl.create(:work_day, user: @hiwi2, date: d2)
    
    login_as @hiwi1
    visit work_days_path
    expect(page).to have_content(l(d1))
    expect(page).to_not have_content(l(d2))
  end
  
  it 'does not show edit button when time sheet is handed in' do
    d1 = Date.today.at_beginning_of_month
    @hiwi1 = FactoryGirl.create(:contract, chair: @chair, start_date: d1, end_date: d1.at_end_of_month).hiwi
    ws = FactoryGirl.create(:work_day, user: @hiwi1, date: d1)
    ws.time_sheet.update!(handed_in: true, hand_in_date: Date.today)

    login_as @hiwi1
    visit work_days_path
    expect(page).to_not have_content('Edit')
  end
  
  # TODO: move all below to features tests
#  
#  it 'rejects a TimeSheet if reject button is pressed' do
#    timesheet = FactoryGirl.create(:time_sheet, user: @user, project: @project, handed_in: true)
#    visit work_days_path(month: Date.today.month, year: Date.today.year, project: @project.id, user_id: @user.id)
#    click_on('reject')
#    timesheet.reload
#    expect(timesheet.status).eql? 'rejected'
#  end
#
#  it 'accepts a TimeSheet if accept button is pressed' do
#    @user.signature = 'Signature'
#    timesheet = FactoryGirl.create(:time_sheet, user: @user, project: @project, handed_in: true)
#    visit work_days_path(month: Date.today.month, year: Date.today.year, project: @project.id, user_id: @user.id)
#    click_on('accept')
#    timesheet.reload
#    expect(timesheet.status).eql? 'accepted'
#  end
#
#  it 'hands in a TimeSheet if hand in button is pressed' do
#    timesheet = FactoryGirl.create(:time_sheet, user: @user, project: @project, handed_in: false)
#    visit work_days_path(month: Date.today.month, year: Date.today.year, project: @project.id, user_id: @user.id)
#    click_on('hand in')
#    timesheet.reload
#    expect(timesheet.handed_in).to be true
#  end
#
#  it 're hands in a TimeSheet if sign button is pressed' do
#    timesheet = FactoryGirl.create(:time_sheet, user: @user, project: @project, handed_in: false, status: 'rejected', signer: @user.id)
#    visit work_days_path(month: Date.today.month, year: Date.today.year, project: @project.id, user_id: @user.id)
#    click_on('hand in')
#    timesheet.reload
#    expect(timesheet.status).eql? ('rejected')
#  end

#  it 'denies the superadmin to access the work days page' do
#    superadmin = FactoryGirl.create(:user, superadmin: true)
#    login_as superadmin
#    visit work_days_path
#    expect(current_path).to eq(dashboard_path)
#  end
end

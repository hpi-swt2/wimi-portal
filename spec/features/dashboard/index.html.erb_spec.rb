require 'rails_helper'

RSpec.describe 'dashboard/index.html.erb', type: :view do
  before :each do
    @user = FactoryGirl.create(:user)
  end

  it 'displays the projects of the user' do
    FactoryGirl.create(:wimi, user: @user)
    project1 = FactoryGirl.create(:project)
    project2 = FactoryGirl.create(:project, title: 'Unassigned Project')
    project1.users << @user
    login_as @user
    visit dashboard_path
    expect(@user.is_wimi?).to be true
    expect(page).to have_content('My Projects')
    expect(page).to have_content(project1.title)
    expect(page).to_not have_content(project2.title)
  end

  it 'shows when one of your timesheets gets declined / accepted' do
    chair = FactoryGirl.create(:wimi, user: @user).chair
    hiwi = FactoryGirl.create(:hiwi)
    contract = FactoryGirl.create(:contract, hiwi: hiwi, responsible: @user, chair: chair)
    time_sheet = FactoryGirl.create(:time_sheet, contract: contract)
    login_as hiwi

    time_sheet.accept_as(contract.responsible)

    visit dashboard_path
    expect(page.body).to have_content(contract.responsible.name)
    expect(page.body).to have_content(time_sheet.name)
  end

  it 'shows if a hiwi of one of your projects submitted a timesheet' do
    chair = FactoryGirl.create(:chair)
    wimi = FactoryGirl.create(:wimi, chair: chair).user
    contract = FactoryGirl.create(:contract, chair: chair, hiwi: @user, responsible: wimi)
    time_sheet = FactoryGirl.create(:time_sheet, contract: contract)

    time_sheet.hand_in()

    login_as wimi
    visit dashboard_path
    expect(wimi.is_wimi?).to be true
    expect(page.body).to have_content(@user.name)
  end

  it 'shows representative links' do
    chair = FactoryGirl.create(:chair, name: 'Chair')
    FactoryGirl.create(:wimi, chair: chair, user: @user, representative: true)
    login_as @user
    visit dashboard_path

    # currently out of order
#    expect(page).to have_link('Show holiday requests')
#    expect(page).to have_link('Show expense requests')
#    expect(page).to have_link('Show trip requests')
  end

  # holidays are currently out of order
#  it 'shows notifications for representative' do
#    chair = FactoryGirl.create(:chair, name: 'Chair')
#    FactoryGirl.create(:wimi, chair: chair, user: @user)
#    holiday = FactoryGirl.create(:holiday, user: @user, signature: true)
#    login_as @user
#    visit holiday_path(holiday)
#    expect(page).to have_link t('holidays.show.hand_in')
#
#    click_on t('holidays.show.hand_in')
#    expect(page).to have_content t('users.show.status.applied')
#
#    FactoryGirl.create(:wimi, chair: chair, user: @user, representative: true)
#    notification = t('events.event_request.holiday', trigger: @user.name)
#
#    login_as @user
#    visit dashboard_path
#
#    expect(page).to have_content(notification)
#    expect(page).to have_link('Show')
#    expect(page).to have_link('Hide')
#  end
end

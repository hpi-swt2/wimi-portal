require 'rails_helper'

RSpec.describe 'dashboard/index.html.erb', type: :view do
  before :each do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  it 'displays the projects of the user' do
    project1 = FactoryGirl.create(:project)
    project2 = FactoryGirl.create(:project, title: 'Unassigned Project')
    project1.users << @user
    login_as @user
    visit dashboard_path
    expect(page).to have_content('My Projects')
    expect(page).to have_content(project1.title)
    expect(page).to_not have_content(project2.title)
  end

  it 'shows content for users without any chair or project' do
    login_as @user
    chair1 = FactoryGirl.create(:chair, name: 'Chair1')
    chair2 = FactoryGirl.create(:chair, name: 'Chair2')
    visit dashboard_path

    expect(page).to have_content(chair1.name)
    expect(page).to have_content(chair2.name)
    expect(page).to have_content(I18n.t('activerecord.attributes.chair.apply'))
  end

  it 'performs an application after click on Apply' do
    login_as @user
    chair1 = FactoryGirl.create(:chair, name: 'Chair1')
    visit dashboard_path

    expect(page).to have_content(chair1.name)
    expect(page).to have_content(I18n.t('activerecord.attributes.chair.apply'))
    expect(page).to_not have_content(I18n.t('activerecord.attributes.chair.application.status.pending'))
    click_on I18n.t('activerecord.attributes.chair.apply')
    visit dashboard_path

    expect(page).to have_content(I18n.t('activerecord.attributes.chair.application.status.pending'))
    expect(page).to_not have_content(I18n.t('activerecord.attributes.chair.apply'))
  end

  it 'shows invitations for projects' do
    login_as @user
    project = FactoryGirl.create(:project)
    project.invite_user(@user, @user)
    visit dashboard_path

    content = I18n.t('event_project_invitations.event_project_invitation.full_html', trigger_name: @user.name, project_name: project.title)
    expect(page).to have_content(content)
  end

  it 'shows when one of your timesheets gets declined / accepted' do
    hiwi = FactoryGirl.create(:hiwi)
    login_as hiwi
    project = FactoryGirl.create(:project)
    time_sheet = FactoryGirl.create(:time_sheet, user_id: hiwi.id, project_id: project.id)
    time_sheet.update(signer: @user.id)
    ActiveSupport::Notifications.instrument("event", {trigger: time_sheet.id, target: hiwi.id, seclevel: :hiwi, type: 'EventTimeSheetAccepted'})

    visit dashboard_path
    expect(page.body).to have_content(@user.name)
    expect(page.body).to have_content(project.title)
    expect(page.body).to have_content(l(Date.new(1, time_sheet.month, 1), format: :without_day_year))
  end

  it 'shows if a hiwi of one of your projects submitted a timesheet' do
    chair = FactoryGirl.create(:chair)
    project = FactoryGirl.create(:project, chair: chair)
    time_sheet = FactoryGirl.create(:time_sheet, user_id: @user.id, project_id: project.id)
    ActiveSupport::Notifications.instrument('event', {trigger: time_sheet.id, target: project.id, seclevel: :wimi, type: 'EventTimeSheetSubmitted'})

    wimi = User.find(FactoryGirl.create(:wimi, chair: chair).user_id)
    wimi.projects << project
    project.users << wimi
    login_as wimi
    visit dashboard_path
    expect(wimi.is_wimi?).to be true
    expect(page.body).to have_content(@user.name)
  end

  it 'hides the content for chairless and projectless users for all other users' do
    chair1 = FactoryGirl.create(:chair, name: 'Chair1')
    chair2 = FactoryGirl.create(:chair, name: 'Chair2')
    chairwimi = ChairWimi.create(user_id: @user.id, chair_id: chair1.id, application: 'accepted')
    login_as @user
    visit dashboard_path

    expect(page).to_not have_content(chair1.name)
    expect(page).to_not have_content(chair2.name)
    expect(page).to_not have_content(I18n.t('activerecord.attributes.chair.apply'))
  end

  it 'displays all chairs if user is superadmin' do
    superadmin = FactoryGirl.create(:user, superadmin: true)
    login_as superadmin

    chair1 = FactoryGirl.create(:chair, name: 'Chair1')
    chair2 = FactoryGirl.create(:chair, name: 'Chair2')

    visit dashboard_path
    expect(page).to have_content(I18n.t('activerecord.models.chair.other'))
    expect(page).to have_content(chair1.name)
    expect(page).to have_content(chair2.name)
    expect(page).to have_link(I18n.t('chair.add_chair'))
  end

  it 'does not display the chair overview for users without superadmin privileges' do
    chair1 = FactoryGirl.create(:chair, name: 'Chair1')
    chair2 = FactoryGirl.create(:chair, name: 'Chair2')
    visit dashboard_path

    expect(page).to_not have_content(chair1.name)
    expect(page).to_not have_content(chair2.name)
    expect(page).to_not have_link(I18n.t('chair.add_chair'))
  end

  it 'shows notifications for the chairs admin' do
    chair1 = FactoryGirl.create(:chair, name: 'Chair1')
    another_user = FactoryGirl.create(:user)
    notification = t('events.event_chair_application', trigger: @user.name)
    login_as @user
    visit dashboard_path

    expect(page).to have_content(chair1.name)
    expect(page).to have_content('Apply as WiMi')
    click_on('Apply as WiMi')
    visit dashboard_path
    expect(page).to_not have_content(notification)

    admin = FactoryGirl.create(:user)
    FactoryGirl.create(:wimi, chair: chair1, user: admin, admin: true)

    login_as admin
    visit dashboard_path

    expect(page).to have_content(notification)
    expect(page).to have_link('Accept')
    expect(page).to have_link('Decline')
    expect(page).to_not have_link('Show holiday requests')
    expect(page).to_not have_link('Show expense requests')
    expect(page).to_not have_link('Show trip requests')
    expect(page).to_not have_link('Apply as WiMi')

    chair2 = FactoryGirl.create(:chair, name: 'Chair2')
    FactoryGirl.create(:wimi, chair: chair2, user: another_user, admin: true)

    login_as another_user
    visit dashboard_path

    expect(page).to_not have_content(notification)
    expect(page).to_not have_link('Accept')
    expect(page).to_not have_link('Decline')
  end

  it 'shows representative links' do
    chair = FactoryGirl.create(:chair, name: 'Chair')
    FactoryGirl.create(:wimi, chair: chair, user: @user, representative: true)
    login_as @user
    visit dashboard_path

    expect(page).to have_link('Show holiday requests')
    expect(page).to have_link('Show expense requests')
    expect(page).to have_link('Show trip requests')
    expect(page).to_not have_link('Apply as WiMi')
  end

  it 'shows notifications for representative' do
    chair = FactoryGirl.create(:chair, name: 'Chair')
    FactoryGirl.create(:wimi, chair: chair, user: @user)
    holiday = FactoryGirl.create(:holiday, user: @user)
    login_as @user
    visit holiday_path(holiday)
    expect(page).to have_link t('holidays.show.file')

    click_on t('holidays.show.file')
    expect(page).to have_content t('users.show.status.applied')

    FactoryGirl.create(:wimi, chair: chair, user: @user, representative: true)
    notification = t('events.event_request.holiday', trigger: @user.name)

    login_as @user
    visit dashboard_path

    expect(page).to have_content(notification)
    expect(page).to have_link('Show')
    expect(page).to have_link('Hide')
  end
end

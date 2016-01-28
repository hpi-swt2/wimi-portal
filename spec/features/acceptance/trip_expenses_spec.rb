require 'rails_helper'
require 'request_macros'

include Warden::Test::Helpers
include RequestMacros

describe 'trips and expenses', type: feature do
  #self.use_transactional_fixtures = false
  before :each do
    chair = FactoryGirl.create(:chair)
    user = FactoryGirl.create(:user)
    @current_user = FactoryGirl.create(:wimi, user_id: user.id, chair_id: chair.id).user
    login_as(@current_user, scope: :user)
  end

  it "creates a business trip from profile page" do
    visit "/users/#{@current_user.id}/"
    click_on(I18n.t('users.show.request_trip'))
    expect(page).to have_content I18n.t('activerecord.attributes.trip.destination')
    expect(page).to have_content I18n.t('activerecord.attributes.trip.reason')
    expect(page).to have_content I18n.t('activerecord.attributes.trip.annotation')
    expect(page).to have_content I18n.t('activerecord.attributes.trip.days_abroad')
    fill_in(I18n.t('activerecord.attributes.trip.destination'), :with => 'Orlando, Florida')
    fill_in(I18n.t('activerecord.attributes.trip.reason'), :with => 'Conference')
    fill_in "trip_date_start", with: I18n.l(Date.today, locale: 'en') #don't run if datepicker was implemented
    fill_in "trip_date_end", with: I18n.l(Date.today+10, locale: 'en') #don't run if datepicker was implemented
    fill_in("trip_days_abroad", with: 1)
    click_on(I18n.t('helpers.submit.create', model: I18n.t('activerecord.models.trip.one')))
    expect(page).to have_content I18n.t('trip.save')
    expect(page).to have_content I18n.t('helpers.links.edit')
    expect(page).to have_content I18n.t('status.saved') #as status
    expect(page).to have_content I18n.t('helpers.links.download')
    expect(page).to have_content I18n.t('helpers.links.hand_in') #to submit it to the chair representative
    visit "/users/#{@current_user.id}/"
  end

  it "submits the request for a business trip" do #ready
    @trip = FactoryGirl.create(:trip, user_id: @current_user.id)
    visit "/users/#{@current_user.id}/"
    click_on(I18n.t('helpers.links.show_details'))
    click_on(I18n.t('helpers.links.hand_in'))
    expect(page).to have_content I18n.t('status.applied')
    expect(page).to_not have_content I18n.t('helpers.links.edit')
    visit "/users/#{@current_user.id}/"
    expect(page).to have_content I18n.t('status.applied') #as status of submitted request
  end

  it "adds expenses to a business trip"  do
    @trip = FactoryGirl.create(:trip, user_id: @current_user.id)
    visit "/users/#{@current_user.id}/"
    click_on(I18n.t('helpers.links.show_details'))
    expect(page).to have_content I18n.t('activerecord.attributes.trip.date_start')
    expect(page).to have_content I18n.t('activerecord.attributes.trip.date_end')
    expect(page).to have_content I18n.t('trips.show.duration', days: @trip.total_days) #show number of days
    expect(page).to have_content I18n.t('trips.show.expense')
    click_on(I18n.t('trips.show.create_expense'))
    fill_in(I18n.t('activerecord.attributes.expense.location_from'), :with => 'Potsdam')
    fill_in(I18n.t('activerecord.attributes.expense.location_to'), :with => 'redrum')
    fill_in(I18n.t('activerecord.attributes.expense.time_start'), :with => '12:00')
    fill_in(I18n.t('activerecord.attributes.expense.time_end'), :with => '13:00')
    click_on(I18n.t('helpers.submit.create', model: I18n.t('activerecord.models.expense.one')))
    expect(page).to have_content I18n.t('expense.save')
    expect(page).to have_content I18n.l(@trip.date_start)
    #expect page to have automatically the same date as given by the related business trip
    visit "/users/#{@current_user.id}/"
  end
end

require 'rails_helper'
require 'request_macros'

include Warden::Test::Helpers
include RequestMacros

describe 'trips and expenses', type: feature do
  #self.use_transactional_fixtures = false
  before :each do
    chair = FactoryGirl.create(:chair)
    user = FactoryGirl.create(:user)
    @current_user = FactoryGirl.create(:chair_wimi, user_id: user.id, chair_id: chair.id).user
    login_as(@current_user, scope: :user)
  end

  it "creates a business trip from profile page" do
    visit "/users/#{@current_user.id}/"
    click_on('New Trip')
    expect(page).to have_content 'Destination'
    expect(page).to have_content 'Reason'
    expect(page).to have_content 'Annotations'
    expect(page).to have_content 'Days abroad'
    fill_in('Destination', :with => 'Orlando, Florida')
    fill_in('Reason', :with => 'Conference')
    select_date Date.today, :from => "trip_trip_datespans_attributes_0_start_date" #don't run if datepicker was implemented
    select_date Date.today+10, :from => "trip_trip_datespans_attributes_0_end_date" #don't run if datepicker was implemented
    click_on('Save')
    expect(page).to have_content 'Trip was successfully created'
    expect(page).to have_content 'Edit'
    expect(page).to have_content 'Saved' #as status
    expect(page).to have_content 'Download as PDF'
    expect(page).to have_content 'Submit' #to submit it to the chair representative
    visit "/users/#{@current_user.id}/"
  end

  it "submits the request for a business trip" do #ready
    @trip = FactoryGirl.create(:trip)
    FactoryGirl.create(:trip_datespan, trip: @trip)
    visit "/users/#{@current_user.id}/"
    click_on('Show Details')
    click_on('Submit')
    expect(page).to have_content 'Submitted on'
    expect(page).to_not have_content 'Edit'
    visit "/users/#{@current_user.id}/"
    expect(page).to have_content 'Submitted' #as status of submitted request
  end

  it "adds expenses to a business trip"  do
    @trip = FactoryGirl.create(:trip)
    FactoryGirl.create(:trip_datespan, trip: @trip)
    visit "/users/#{@current_user.id}/"
    click_on('Show Details')
    expect(page).to have_content 'Start Date'
    expect(page).to have_content 'End Date'
    expect(page).to have_content 'Duration' #show number of days
    expect(page).to have_content 'Expenses'
    click_on('Create Travel Expense Report')
    fill_in('Starting in', :with => 'Potsdam')
    click_on('Save')
    expect(page).to have_content 'Travel Expense Report was successfully created'
    #expect page to have automatically the same date as given by the related business trip
    visit "/users/#{@current_user.id}/"
    #should only show location from/to and the edit button,
    #everything else is shown on the expense report detail page
    expect(page).to have_content 'Edit Report'
    expect(page).to have_content 'Location from'
    expect(page).to have_content 'Location to'
    expect(page).to_not have_content 'Inland'
    expect(page).to_not have_content 'Location via'
    expect(page).to_not have_content 'Reason'
    expect(page).to_not have_content 'Car'
    expect(page).to_not have_content 'Public transport'
    expect(page).to_not have_content 'Hotel'
    expect(page).to_not have_content 'Vehicle advance'
    expect(page).to_not have_content 'General advance'
    expect(page).to_not have_content 'User'
  end
end

namespace :db do
  task add_demo_data: :environment do
    # define users
    epic_admin = User.create!(first_name: 'Admin', last_name: 'Epic', email: 'admin@epic.de')
    epic_representative = User.create!(first_name: 'Representative', last_name: 'Epic', email: 'representative@epic.de')
    meinel_both = User.create!(first_name: 'Admin-Representative', last_name: 'Meinel', email: 'admin.representative@meinel.de')
    wimi_epic = User.create!(first_name: 'Wimi', last_name: 'Epic', email: 'wimi@epic.de')
    pending_wimi_appl = User.create!(first_name: 'Wimi-Pending', last_name: 'Epic', email: 'wimi.pending@epic.de')
    alice = User.create!(first_name: 'Alice', last_name: 'A', email: 'alice@user.de')
    User.create!(first_name: 'Bob', last_name: 'B', email: 'bob@user.de')

    # create! chairs
    chair1 = Chair.create!(name: 'Epic', description: 'Enterprise Platform and Integration Concepts')
    chair2 = Chair.create!(name: 'Meinel', description: 'Internet-Technologien und -Systeme')

    swt2 = Project.create!(title: "Softwaretechnik II")
    swt2.users << epic_admin
    swt2.users << alice
    chair1.projects << swt2

    # set user roles
    ChairWimi.create!(chair_id: chair1.id, user_id: epic_admin.id, admin: true, application: "accepted")
    ChairWimi.create!(chair_id: chair1.id, user_id: epic_representative.id, representative: true, application: "accepted")
    ChairWimi.create!(chair_id: chair2.id, user_id: meinel_both.id, admin: true, representative: true, application: "accepted")
    ChairWimi.create!(chair_id: chair1.id, user_id: wimi_epic.id, application: 'applied')
    ChairWimi.create!(chair_id: chair1.id, user_id: pending_wimi_appl.id, application: 'pending')

    # create some holidays, trips, expenses
    Holiday.create!(start: Date.today(), end: Date.today + 4, length: 5, user_id: epic_admin.id, status: 'applied', last_modified: Date.today)

    User.create!(email: "test@test.de",
      first_name: "Max",
      last_name: "Mustermann")
    Holiday.create!(start: Date.today-1,
      end: Date.today,
      user_id: epic_admin.id)
    Holiday.create!(status: :declined,
      start: Date.today-7,
      end: Date.today-6,
      user_id: epic_representative)
    WorkDay.create!(
      date: '2015-11-18',
      start_time: '2015-11-18 15:11:53',
      break: 30,
      end_time: '2015-11-18 16:11:53',
      user_id: alice.id,
      project_id: swt2.id)
    WorkDay.create!(
      date: '2015-11-26',
      start_time: '2015-11-26 10:00:00',
      break: 0,
      end_time: '2015-11-26 18:00:00',
      user_id: alice.id,
      project_id: swt2.id)
    TimeSheet.create!(
      month: 11,
      year: 2015,
      salary: 9,
      salary_is_per_month: true,
      workload: 40,
      workload_is_per_month: true,
      user_id: alice.id,
      project_id: swt2.id)
    Trip.create!(
      destination: 'ME310 Kickoff USA',
      reason: 'ME310',
      annotation: 'Sample Trip',
      signature: true,
      trip_datespans_attributes: [{
        start_date: Date.today,
        end_date: Date.today + 10,
        days_abroad: 5}],
      user: epic_representative)
    Trip.create!(
      destination: 'Ridiculous Meeting',
      reason: 'Party',
      annotation: 'Sample declined Trip',
      signature: true,
      trip_datespans_attributes: [{
        start_date: Date.today + 7,
        end_date: Date.today + 10,
        days_abroad: 2}],
      status: :declined,
      user: meinel_both)
    TravelExpenseReport.create!(
      inland: true,
      country: 'Germany',
      location_from: 'Potsdam',
      location_to: 'München',
      reason: 'Hana Things',
      date_start: 8.days.ago,
      date_end: DateTime.now,
      public_transport: true,
      hotel: true,
      general_advance: 2000,
      user: meinel_both,
      travel_expense_report_items_attributes: [
        {
        date: 5.days.ago,
        breakfast: false,
        lunch: true,
        dinner: true},
        {
        date: 4.days.ago,
        breakfast: true,
        lunch: false,
        dinner: false}
      ])
  end
end
namespace :db do
  task add_demo_data: :environment do
    # define users
    epic_admin = User.create!(first_name: 'Admin', last_name: 'Epic', email: 'epic.admin@example.com', username: 'admin', password: '1234')
    epic_representative = User.create!(first_name: 'Representative', last_name: 'Epic', email: 'rep@example.com', username: 'representative', password: '1234')
    epic_wimi = User.create!(first_name: 'Wimi', last_name: 'Epic', email: 'wimi@example.com', username: 'wimi', password: '1234')

    alice = User.create!(first_name: 'Alice', last_name: 'A', email: 'alice@example.com', username: 'alice', password: '1234')
    bob = User.create!(first_name: 'Bob', last_name: 'B', email: 'bob@example.com', username: 'bob', password: '1234')

    # create! chairs
    chair_epic = Chair.create!(name: 'EPIC', description: 'Enterprise Platform and Integration Concepts')
    chair_www = Chair.create!(name: 'Internet', description: 'Internet-Technologien und -Systeme')

    # set user roles
    ChairWimi.create!(chair_id: chair_epic.id, user_id: epic_admin.id, admin: true, application: 'accepted')
    ChairWimi.create!(chair_id: chair_epic.id, user_id: epic_representative.id, representative: true, application: 'accepted')
    ChairWimi.create!(chair_id: chair_epic.id, user_id: epic_wimi.id, application: 'accepted')

    # projects
    swt2 = Project.create!(title: 'Softwaretechnik II', chair: chair_epic)
    swt2.users << epic_wimi
    swt2.users << alice

    hana_project = Project.create!(title: 'HANA Project', chair: chair_epic)
    hana_project.users << epic_representative
    hana_project.users << bob

    # create some holidays, trips, expenses
    if (Date.today.day > 2)
      day1 = Date.today - 2
      day2 = Date.today
    else
      day1 = Date.today
      day2 = Date.today + 2
    end
  
    Holiday.create!(start: Date.today, end: Date.today + 19, length: 5, user_id: epic_admin.id, status: 'applied', last_modified: Date.today)

    Holiday.create!(start: day2 - 1,
      end: day2,
      length: 1,
      user_id: epic_admin.id)
    Holiday.create!(status: :declined,
      start: Date.today - 7,
      end: Date.today - 6,
      length: 1,
      user_id: epic_representative.id)
    WorkDay.create!(
      date: day1,
      start_time: day1.to_s + ' 15:11:53',
      break: 30,
      end_time: day1.to_s + ' 16:11:53',
      user_id: alice.id,
      project_id: swt2.id)
    WorkDay.create!(
      date: day2,
      start_time: day2.to_s + ' 10:00:00',
      break: 0,
      end_time: day2.to_s + ' 18:00:00',
      user_id: alice.id,
      project_id: swt2.id)
    WorkDay.create!(
      date: day2,
      start_time: day2.to_s + ' 10:00:00',
      break: 0,
      end_time: day2.to_s + ' 12:00:00',
      user_id: bob.id,
      project_id: hana_project.id)
    TimeSheet.create!(
      month: day2.month,
      year: day2.year,
      salary: 9,
      salary_is_per_month: true,
      workload: 40,
      workload_is_per_month: true,
      user_id: alice.id,
      project_id: swt2.id)
    trip = Trip.create!(
      destination: 'ME310 Kickoff USA',
      reason: 'ME310',
      annotation: 'Sample Trip',
      signature: true,
      date_start: Date.today,
      date_end: Date.today + 10,
      days_abroad: 5,
      user: epic_representative)
    Trip.create!(
      destination: 'Ridiculous Meeting',
      reason: 'Party',
      annotation: 'Sample declined Trip',
      signature: true,
      date_start: Date.today + 7,
      date_end: Date.today + 10,
      days_abroad: 2,
      status: :declined,
      user: epic_wimi)
    Expense.create!(
      inland: true,
      country: 'Germany',
      location_from: 'Potsdam',
      reason: 'Hana Things',
      time_start: "12:00",
      time_end: "14:00",
      public_transport: true,
      hotel: true,
      general_advance: 2000,
      user: epic_representative,
      trip: trip)
    trip.update(date_start: Date.today)
  end
end
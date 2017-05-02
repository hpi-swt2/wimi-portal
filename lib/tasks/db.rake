namespace :db do
  task add_demo_data: :environment do
    # define users
    epic_admin = User.create!(first_name: 'Admin', last_name: 'Epic', email: 'epic.admin@example.com', username: 'admin', password: '1234')
    epic_representative = User.create!(first_name: 'Representative', last_name: 'Epic', email: 'rep@example.com', username: 'representative', password: '1234')
    epic_wimi = User.create!(first_name: 'Wimi', last_name: 'Epic', email: 'wimi@example.com', username: 'wimi', password: '1234')

    alice = User.create!(first_name: 'Alice', last_name: 'A', email: 'alice@example.com', username: 'alice', password: '1234')
    bob = User.create!(first_name: 'Bob', last_name: 'B', email: 'bob@example.com', username: 'bob', password: '1234')
    charlie = User.create!(first_name: 'Charlie', last_name: 'C', email: 'charlie@example.com', username: 'charlie', password: '1234')

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

    #contracts

    contract_alice = Contract.create(
        hiwi: alice, 
        chair: chair_www, 
        start_date: Date.today, 
        end_date: Date.today >> 6, 
        responsible: epic_wimi,
        flexible: false, 
        hours_per_week: 10,
        wage_per_hour: 12.5)

    contract_bob = Contract.create(
        hiwi: bob, 
        chair: chair_epic, 
        start_date: Date.today, 
        end_date: Date.today >> 6, 
        responsible: epic_wimi,
        flexible: false, 
        hours_per_week: 10,
        wage_per_hour: 12.5)

    contract_charlie = Contract.create(
        hiwi: charlie, 
        chair: chair_epic, 
        start_date: Date.today, 
        end_date: Date.today >> 6, 
        responsible: epic_wimi,
        flexible: false, 
        hours_per_week: 12,
        wage_per_hour: 20)

    #time_sheets

    time_sheet_bob = TimeSheet.create(
        contract: contract_bob,
        month: Date.today.month,
        year: Date.today.year)

    time_sheet_bob.work_days.create(
        date: time_sheet_bob.first_day, 
        start_time: "12:00", 
        break: 60,
        end_time: "15:00",
        notes: "Lorem ipsum dolor sit amet",
        project: hana_project)
    time_sheet_bob.work_days.create(
        date: time_sheet_bob.first_day + 1, 
        start_time: "12:00", 
        break: 60,
        end_time: "15:00",
        notes: "Lorem ipsum dolor sit amet",
        project: hana_project)
    time_sheet_bob.work_days.create(
        date: time_sheet_bob.first_day + 10, 
        start_time: "12:00", 
        break: 60,
        end_time: "15:00",
        notes: "Lorem ipsum dolor sit amet",
        project: swt2)

    time_sheet_charlie = TimeSheet.create(
        contract: contract_charlie,
        month: Date.today.month,
        year: Date.today.year)

    time_sheet_charlie.work_days.create(
        date: time_sheet_charlie.first_day, 
        start_time: "10:00", 
        break: 60,
        end_time: "18:00",
        notes: "Lorem ipsum dolor sit amet",
        project: swt2)

  end
end
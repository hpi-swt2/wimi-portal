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

  end
end
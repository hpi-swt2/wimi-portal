namespace :db do
  task add_demo_data: :environment do
    # define users
    epic_admin = User.create(first_name: 'Admin', last_name: 'Epic', email: 'admin@epic.de')
    epic_representative = User.create(first_name: 'Representative', last_name: 'Epic', email: 'representative@epic.de')
    meinel_both = User.create(first_name: 'Admin-Representative', last_name: 'Meinel', email: 'admin.representative@meinel.de')
    wimi_epic = User.create(first_name: 'Wimi', last_name: 'Epic', email: 'wimi@epic.de')
    pending_wimi_appl = User.create(first_name: 'Wimi-Pending', last_name: 'Epic', email: 'wimi.pending@epic.de')
    alice = User.create(first_name: 'Alice', last_name: 'A', email: 'alice@user.de')
    User.create(first_name: 'Bob', last_name: 'B', email: 'bob@user.de')

    # create chairs
    chair1 = Chair.create(name: 'Epic', description: 'Enterprise Platform and Integration Concepts')
    chair2 = Chair.create(name: 'Meinel', description: 'Internet-Technologien und -Systeme')

    swt2 = Project.create(title: "Softwaretechnik II")
    swt2.users << epic_admin
    swt2.users << alice
    chair1.projects << swt2

    # set user roles
    ChairWimi.create(chair_id: chair1.id, user_id: epic_admin.id, admin: true, application: "accepted")
    ChairWimi.create(chair_id: chair1.id, user_id: epic_representative.id, representative: true, application: "accepted")
    ChairWimi.create(chair_id: chair2.id, user_id: meinel_both.id, admin: true, representative: true, application: "accepted")
    ChairWimi.create(chair_id: chair1.id, user_id: wimi_epic.id, application: 'applied')
    ChairWimi.create(chair_id: chair1.id, user_id: pending_wimi_appl.id, application: 'pending')

    # create some holidays, trips, expenses
    Holiday.create(start: Date.today(), end: Date.new(Date.today.year, Date.today.month, Date.today.day + 4), length: 5, user_id: epic_admin.id, status: 'applied', last_modified: Date.today)

    User.create(email: "test@test.de",
      first_name: "Max",
      last_name: "Mustermann")
    # Holiday.create(start: Date.today-1,
    #   end: Date.today,
    #   user_id: 1)
    # Holiday.create(status: "Declined",
    #   start: Date.today-7,
    #   end: Date.today-6,
    #   user_id: 1)
    # Publication.create(title: "Semantic Web Research Results",
    #   venue: "CGM",
    #   type_: "Paper",
    #   project_id: 1)
    # Trip.create(title: "ME310 Kickoff USA",
    #   start: Date.today-3,
    #   end: Date.today,
    #   status: "Approved",
    #   user_id: 1)
    # Trip.create(title: "Softwaretechnik Intro",
    #   start: Date.today-1,
    #   end: Date.today,
    #   status: "Declined",
    #   user_id: 1)
  end
end
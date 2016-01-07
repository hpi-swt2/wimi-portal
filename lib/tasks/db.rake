namespace :db do
  task :add_demo_data => :environment do
    joe = User.create(first_name: 'John', last_name: 'Doe', email: 'john.doe@student.hpi.de')
    epic = Chair.create(name: 'EPIC')
    joe_hiwi = ChairWimi.create(user: joe, chair: epic, admin: true)
    swt2 = Project.create(title: "Softwaretechnik II")
    swt2.users << joe
    epic.projects << swt2

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
    # Expense.create(amount: 200,
    #   purpose: "Clubmate",
    #   comment: "ist ein koffeinhaltiges, alkoholfreies Erfrischungsgetränk der Brauerei Loscher aus Münchsteinach",
    #   user_id: 1,
    #   project_id: nil,
    #   trip_id: nil)
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
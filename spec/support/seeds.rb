# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
Project.create(title: 'Softwaretechnik II')
User.create(email: 'test@test.de',
  sign_in_count: 1,
  first: 'Max',
  last_name: 'Mustermann')
Holiday.create(status: 'Approved',
  start: Date.today - 1,
  end: Date.today,
  user_id: 1)
Holiday.create(status: 'Declined',
  start: Date.today - 7,
  end: Date.today - 6,
  user_id: 1)
Publication.create(title: 'Semantic Web Research Results',
  venue: 'CGM',
  type_: 'Paper',
  project_id: 1)
Expense.create(amount: 200,
  purpose: 'Clubmate',
  comment: 'ist ein koffeinhaltiges, alkoholfreies Erfrischungsgetränk der Brauerei Loscher aus Münchsteinach',
  user_id: 1,
  project_id: nil,
  trip_id: nil)
Trip.create(title: 'ME310 Kickoff USA',
  start: Date.today - 3,
  end: Date.today,
  status: 'Approved',
  user_id: 1)
Trip.create(title: 'Softwaretechnik Intro',
  start: Date.today - 1,
  end: Date.today,
  status: 'Declined',
  user_id: 1)

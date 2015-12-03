# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
Project.create(title: 'Softwaretechnik II')
User.create(email: 'test@test.de',
  encrypted_password: '$2a$10$bM7/hI5w9x5IlJ.kPZE/x.CqwJInLufaCIgaZ2iFG3je3CFzd83B2',
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
Trip.create(name: 'ME310 Kickoff USA',
            destination: 'USA',
            reason: 'Meeting',
            start_date: Date.today - 3,
            end_date: Date.today,
            days_abroad: '3',
            annotation: 'Important',
            signature: 'Hasso',
            user_id: 1)
Trip.create(name: 'Softwaretechnik Intro',
            destination: 'HPI',
            reason: 'lazy',
            start_date: Date.today - 1,
            end_date: Date.today,
            days_abroad: 1,
user_id: 1)

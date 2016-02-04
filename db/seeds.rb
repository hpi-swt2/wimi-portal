Chair.create(name: 'Enterprise Platform and Integration Concepts')
Chair.create(name: 'Internet-Technologien und Systeme')
Chair.create(name: 'Human Computer Interaction')
Chair.create(name: 'Computergrafische Systeme')
Chair.create(name: 'Systemanalyse und Modellierung')
Chair.create(name: 'Software-Architekturen')
Chair.create(name: 'Informationssysteme')
Chair.create(name: 'Betriebssysteme und Middleware')
Chair.create(name: 'Business Process Technology')
Chair.create(name: 'Knowledge Discovery and Data Mining')
Chair.create(name: 'School of Design Thinking')

User.create(first_name: 'Super', last_name: 'Admin', email: 'super.admin@student.hpi.uni-potsdam.de', username: 'superadmin', password: 'test', password_confirmation: 'test', superadmin: true)
User.create(first_name: 'Karl', last_name: 'Algo', email: 'karl.algo@student.hpi.uni-potsdam.de', password: 'test', password_confirmation: 'test')
User.create(first_name: 'Sara', last_name: 'Algo', email: 'sara.algo@student.hpi.uni-potsdam.de', password: 'test', password_confirmation: 'test')

User.create(first_name: 'Hans', last_name: 'Epic', email: 'hans.epic@student.hpi.uni-potsdam.de', password: 'test', password_confirmation: 'test')
User.create(first_name: 'Laura', last_name: 'Epic', email: 'laura.epic@student.hpi.uni-potsdam.de', password: 'test', password_confirmation: 'test')
User.create(first_name: 'Franz', last_name: 'Epic', email: 'franz.epic@student.hpi.uni-potsdam.de', password: 'test', password_confirmation: 'test')
User.create(first_name: 'Thomas', last_name: 'Epic', email: 'thomas.epic@student.hpi.uni-potsdam.de', password: 'test', password_confirmation: 'test')
User.create(first_name: 'Carlos', last_name: 'Epic', email: 'carlos.epic@student.hpi.uni-potsdam.de', password: 'test', password_confirmation: 'test')

ChairWimi.create(admin: false, representative: false, user_id: 4, chair_id: 1)
ChairWimi.create(admin: false, representative: false, user_id: 5, chair_id: 1)
ChairWimi.create(admin: false, representative: false, user_id: 6, chair_id: 1)
ChairWimi.create(admin: false, representative: false, user_id: 7, chair_id: 1)
ChairWimi.create(admin: false, representative: false, user_id: 8, chair_id: 1)

Project.create(title: 'In-Memory Data Management for Enterprise Systems', chair_id: 1)
Project.create(title: 'Tools & Methods for Enterprise Systems Design and Engineering', chair_id: 1)
Project.create(title: 'In-Memory Data Management for Life Sciences', chair_id: 1)
project4 = Project.create(title: 'openHPI', chair_id: 1)

## Hiwis mit Stundenzetteln ##

user9 = User.create(first_name: 'Peter', last_name: 'Hiwi', email: 'peter.hiwi@student.hpi.uni-potsdam.de', password: 'test', password_confirmation: 'test')
user10 = User.create(first_name: 'Paul', last_name: 'Hiwi', email: 'paul.hiwi@student.hpi.uni-potsdam.de', password: 'test', password_confirmation: 'test')

project4.users << user9
project4.users << user10

#ProjectsUser.create(user_id: 9, project_id: 4)
#ProjectsUser.create(user_id: 10, project_id: 4)

TimeSheet.create(month: 2, year: 2016, salary: 400, salary_is_per_month: true, workload: 10, workload_is_per_month: true, user_id: 10, project_id: 4)
TimeSheet.create(month: 2, year: 2016, salary: 400, salary_is_per_month: true, workload: 10, workload_is_per_month: true, user_id: 9, project_id: 4)

WorkDay.create(date: '2016-02-01', start_time: '08:00:00', end_time: '19:00:00', break: 60, user_id: 9, project_id: 4)
WorkDay.create(date: '2016-02-02', start_time: '08:00:00', end_time: '19:00:00', break: 60, user_id: 9, project_id: 4)
WorkDay.create(date: '2016-02-01', start_time: '08:00:00', end_time: '16:00:00', break: 60, user_id: 10, project_id: 4)
WorkDay.create(date: '2016-02-02', start_time: '08:00:00', end_time: '17:00:00', break: 60, user_id: 10, project_id: 4)

TimeSheet.last.update(handed_in: true, hand_in_date: '2016-02-04')

## Uns anlegen ##

user11 = User.create(first_name: 'Mandy', last_name: 'Klingbeil', email: 'mandy.klingbeil@student.hpi.uni-potsdam.de', identity_url: 'https://openid.hpi.uni-potsdam.de/user/mandy.klingbeil')
User.create(first_name: 'Fabian', last_name: 'Paul', email: 'fabian.paul@student.hpi.uni-potsdam.de', identity_url: 'https://openid.hpi.uni-potsdam.de/user/fabian.paul')

ChairWimi.create(admin: true, representative: false, user_id: 11, chair_id: 1)
ChairWimi.create(admin: false, representative: true, user_id: 12, chair_id: 1)

project4.users << user11

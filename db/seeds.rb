chair1 = Chair.create(name: 'Enterprise Platform and Integration Concepts')
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

user4 = User.create(first_name: 'Hans', last_name: 'Epic', email: 'hans.epic@student.hpi.uni-potsdam.de', password: 'test', password_confirmation: 'test')
user5 = User.create(first_name: 'Laura', last_name: 'Epic', email: 'laura.epic@student.hpi.uni-potsdam.de', password: 'test', password_confirmation: 'test')
user6 = User.create(first_name: 'Franz', last_name: 'Epic', email: 'franz.epic@student.hpi.uni-potsdam.de', password: 'test', password_confirmation: 'test')
user7 = User.create(first_name: 'Thomas', last_name: 'Epic', email: 'thomas.epic@student.hpi.uni-potsdam.de', password: 'test', password_confirmation: 'test')
user8 = User.create(first_name: 'Carlos', last_name: 'Epic', email: 'carlos.epic@student.hpi.uni-potsdam.de', password: 'test', password_confirmation: 'test')

ChairWimi.create(admin: true, representative: false, application: 'accepted', user_id: 4, chair_id: 1)
ChairWimi.create(admin: false, representative: false, application: 'accepted', user_id: 5, chair_id: 1)
ChairWimi.create(admin: false, representative: false, application: 'accepted', user_id: 6, chair_id: 1)
ChairWimi.create(admin: false, representative: false, application: 'accepted', user_id: 7, chair_id: 1)
ChairWimi.create(admin: false, representative: false, application: 'accepted', user_id: 8, chair_id: 1)

project1 = Project.create(title: 'In-Memory Data Management for Enterprise Systems', chair_id: 1)
project2 = Project.create(title: 'Tools & Methods for Enterprise Systems Design and Engineering', chair_id: 1)
project3 = Project.create(title: 'In-Memory Data Management for Life Sciences', chair_id: 1)
project4 = Project.create(title: 'openHPI', chair_id: 1)

## create student assistants with time sheets ##

user9 = User.create(first_name: 'Peter', last_name: 'Hiwi', email: 'peter.hiwi@student.hpi.uni-potsdam.de', password: 'test', password_confirmation: 'test')
user10 = User.create(first_name: 'Paul', last_name: 'Hiwi', email: 'paul.hiwi@student.hpi.uni-potsdam.de', password: 'test', password_confirmation: 'test')

project4.users << user4
project4.users << user9
project4.users << user10

TimeSheet.create(month: 2, year: 2016, salary: 400, salary_is_per_month: true, workload: 10, workload_is_per_month: true, user_id: 10, project_id: 4)
TimeSheet.create(month: 2, year: 2016, salary: 400, salary_is_per_month: true, workload: 10, workload_is_per_month: true, user_id: 9, project_id: 4)

WorkDay.create(date: '2016-02-01', start_time: '08:00:00', end_time: '19:00:00', break: 60, user_id: 9, project_id: 4)
WorkDay.create(date: '2016-02-02', start_time: '08:00:00', end_time: '19:00:00', break: 60, user_id: 9, project_id: 4)
WorkDay.create(date: '2016-02-01', start_time: '08:00:00', end_time: '16:00:00', break: 60, user_id: 10, project_id: 4)
WorkDay.create(date: '2016-02-02', start_time: '08:00:00', end_time: '17:00:00', break: 60, user_id: 10, project_id: 4)

TimeSheet.last.update(handed_in: true, hand_in_date: '2016-02-04')

user11 = User.create(first_name: 'Mandy', last_name: 'SWT2', email: 'mandy.swt2@student.hpi.uni-potsdam.de')
User.create(first_name: 'Fabian', last_name: 'SWT2', email: 'fabian.swt2@student.hpi.uni-potsdam.de')
user13 = User.create(first_name: 'Julian', last_name: 'SWT2', email: 'julian.swt2@student.hpi.uni-potsdam.de')

ChairWimi.create(admin: false, representative: true, user_id: 11, chair_id: 1)
ChairWimi.create(admin: true, representative: false, user_id: 12, chair_id: 1)
#ChairWimi.create(admin: false, representative: false, application: 'accepted', user_id: 13, chair_id: 1)

project4.users << user11
#project4.users << user13

## create more users for statistics ##
user14 = User.create(first_name: 'Merle', last_name: 'Epic', email: 'merle.epic@student.hpi.uni-potsdam.de', password: 'test', password_confirmation: 'test')
user15 = User.create(first_name: 'Manfred', last_name: 'Epic', email: 'manfred.epic@student.hpi.uni-potsdam.de', password: 'test', password_confirmation: 'test')
user16 = User.create(first_name: 'Gustus', last_name: 'Epic', email: 'gustus.epic@student.hpi.uni-potsdam.de', password: 'test', password_confirmation: 'test')
project2.users << user14
project1.users << user15
project3.users << user16

TimeSheet.create(month: 2, year: 2016, salary: 200, salary_is_per_month: true, workload: 5, workload_is_per_month: true, user_id: 14, project_id: 2)
WorkDay.create(date: '2016-02-01', start_time: '08:00:00', end_time: '12:00:00', break: 60, user_id: 14, project_id: 2)
WorkDay.create(date: '2016-02-03', start_time: '10:00:00', end_time: '12:00:00', break: 60, user_id: 14, project_id: 2)

TimeSheet.create(month: 2, year: 2016, salary: 250, salary_is_per_month: true, workload: 7, workload_is_per_month: true, user_id: 15, project_id: 1)
WorkDay.create(date: '2016-02-01', start_time: '08:00:00', end_time: '11:00:00', break: 60, user_id: 15, project_id: 1)
WorkDay.create(date: '2016-02-03', start_time: '10:00:00', end_time: '12:00:00', break: 60, user_id: 15, project_id: 1)

TimeSheet.create(month: 2, year: 2016, salary: 450, salary_is_per_month: true, workload: 10, workload_is_per_month: true, user_id: 16, project_id: 3)
WorkDay.create(date: '2016-02-01', start_time: '08:00:00', end_time: '10:00:00', break: 60, user_id: 16, project_id: 3)
WorkDay.create(date: '2016-02-03', start_time: '10:00:00', end_time: '16:00:00', break: 60, user_id: 16, project_id: 3)

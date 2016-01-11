# define the account, which has privileges of a superadmin
User.create(first_name: 'First', last_name: 'Last', email: 'first.last@student.hpi.uni-potsdam.de', identity_url: 'https://openid.hpi.uni-potsdam.de/user/first.last', superadmin: true)

# define users
epic_admin = User.create(first_name: 'Admin', last_name: 'Epic', email: 'admin@epic.de')
epic_representative = User.create(first_name: 'Representative', last_name: 'Epic', email: 'representative@epic.de')
meinel_both = User.create(first_name: 'Admin-Representative', last_name: 'Meinel', email: 'admin.representative@meinel.de')
wimi_epic = User.create(first_name: 'Wimi', last_name: 'Epic', email: 'wimi@epic.de')
pending_wimi_appl = User.create(first_name: 'Wimi-Pending', last_name: 'Epic', email: 'wimi.pending@epic.de')
User.create(first_name: 'Alice', last_name: 'A', email: 'alice@user.de')
User.create(first_name: 'Bob', last_name: 'B', email: 'bob@user.de')

# create chairs
chair1 = Chair.create(name: 'Epic', description: 'Enterprise Platform and Integration Concepts')
chair2 = Chair.create(name: 'Meinel', description: 'Internet-Technologien und -Systeme')

# set user roles
ChairWimi.create(chair_id: chair1.id, user_id: epic_admin.id, admin: true, application: "accepted")
ChairWimi.create(chair_id: chair1.id, user_id: epic_representative.id, representative: true, application: "accepted")
ChairWimi.create(chair_id: chair2.id, user_id: meinel_both.id, admin: true, representative: true, application: "accepted")
ChairWimi.create(chair_id: chair1.id, user_id: wimi_epic.id, application: 'applied')
ChairWimi.create(chair_id: chair1.id, user_id: pending_wimi_appl.id, application: 'pending')

# create some holidays, trips, expenses
Holiday.create(start: Date.today(), end: Date.new(Date.today.year, Date.today.month, Date.today.day + 4), user_id: epic_admin.id, status: "applied")


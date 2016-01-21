# define the account, which has privileges of a superadmin
User.create(first_name: 'Super', last_name: 'Admin', email: 'super.admin@student.hpi.uni-potsdam.de', username: 'wimi-admin', password: 'thisisnotthepasswordforthewimiportal', password_confirmation: 'thisisnotthepasswordforthewimiportal', superadmin: true)

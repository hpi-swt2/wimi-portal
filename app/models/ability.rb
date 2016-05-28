class Ability
  include CanCan::Ability

  def initialize(user)
    unless user.nil?
      check_functions = [:is_superadmin?, :is_admin?, :is_representative?,
                         :is_wimi?, :is_hiwi?, :is_user?]
      initialize_functions = [:initialize_superadmin, :initialize_admin, :initialize_representative,
                              :initialize_wimi, :initialize_hiwi, :initialize_user]

      check_functions.each_with_index do |check_func, index|
        if user.send check_func
          send initialize_functions[index], user
          return
        end
      end
    end
  end

  def initialize_user(user)
    can :show, User
    can :manage, User, id: user.id

    can [:index, :show], Chair

    can [:index, :show], Contract, hiwi_id: user.id
    
    can [:index, :show, :leave], Project, users: { id: user.id }
    
    can [:index, :show], TimeSheet, user: { id: user.id }
    can [:edit, :update, :hand_in], TimeSheet, handed_in: false, user: { id: user.id }
    
    
    can [:new, :create], WorkDay
    can [:index, :show], WorkDay, user: { id: user.id }
    can [:edit, :update, :destroy], WorkDay do |wd|
      wd.user == user and can?(:edit, wd.time_sheet)
    end
  end

  def initialize_hiwi(user)
    initialize_user user
    # hiwi is just a student with a contract,
    # has same rights as everyone
  end

  def initialize_wimi(user)
    initialize_user user
    
    can [:new, :create], Project
    can [:index, :show], Project, chair: { chair_wimis: {user_id: user.id} }
    can :manage, Project, users: { id: user.id }
    cannot :leave, Project do |project|
      project.wimis.size == 1
    end
    
    can [:index, :show], Contract, responsible_id: user.id
    can [:index, :show, :accept, :reject, :accept_reject], TimeSheet do |ts|
      can? :show, ts.contract
    end
    
    can [:new, :create], Holiday
    can [:show, :edit, :update, :destroy, :file], Holiday, user_id: user.id
    
#    can :new, Holiday
#    can :create, Holiday
#    can :new, Expense
#    can :create, Expense
#    can :create_expense, Trip.select{ |t| t.user == user}
#    can :hand_in, Expense.select { |t| t.user == user }
#    can :destroy, Expense.select { |t| t.user == user }
#    can :new, Trip
#    can :create, Trip
#    can :read, Trip.select { |t| t.user == user }
#    can :update, Trip.select { |t| t.user == user }
#    can :edit, Trip.select { |t| t.user == user }
#    can :hand_in, Trip.select { |t| t.user == user }
#    can :destroy, Trip.select { |t| t.user == user }
#    can :see_trips, User do |u|
#      u == user
#    end
#    can :crud, Holiday.select { |h| h.user == user }
#    can :file, Holiday.select { |h| h.user == user }
#
#    can :manage, Expense.select { |t| t.user == user }
#    can :see_holidays, User do |u|
#      u == user
#    end
#    can :edit_leave, User do |u|
#      u == user
#    end
    #can :set aktive/inaktive
    #can :manage, Documents of hiwis in own projects
  end

  def initialize_representative(user)
    initialize_admin user
#
#    can :read, Project do |project|
#      user.chair == project.chair
#    end
#    can :see_holidays, User do |chair_user|
#      chair_user.chair == user.chair
#    end
#    can :see_trips,    User do |chair_user|
#      chair_user.chair == user.chair
#    end
#    
#    can :reject, Holiday.select {|h| h.user != user}
#    can :accept, Holiday.select {|h| h.user != user}
#    can :accept_reject, Holiday.select {|h| h.user != user}
#    can :read,   Holiday do |h|
#      user.is_representative?(h.user.chair)
#      h.status != 'saved' && h.status != 'declined'
#    end
#
#    can :read,      Trip.select { |t| user.is_representative?(t.user.chair) }
#    can :reject,    Trip
#    can :accept,    Trip.select {|h| h.user != user}
#    can :accept_reject, Trip
#    can :edit_trip, Trip do |trip|
#      trip.status != 'saved'
#    end
#    can :read,      Trip do |t|
#      user.is_representative?(t.user.chair)
#      t.status != 'saved' && t.status != 'declined'
#    end
#
#    can :read, Expense.select { |t| user.is_representative?(t.user.chair) }
#
#    can :see,               Chair
#    can :read,              Chair do |chair|
#      user.is_representative?(chair)
#    end
#    can :requests,          Chair do |chair|
#      user.is_representative?(chair)
#    end
#    can :add_requests,      Chair do |chair|
#      user.is_representative?(chair)
#    end
#    can :requests_filtered, Chair do |chair|
#      user.is_representative?(chair)
#    end
#
#    cannot :reject, TimeSheet
#    cannot :accept, TimeSheet
#    cannot :see, TimeSheet
  end

  def initialize_admin(user)
    initialize_wimi user
    
    can [:edit, :requests, :requests_filtered, :remove_from_chair, :set_admin, :withdraw_admin], Chair, chair_wimis: {user_id: user.id}
    can :manage, Contract, chair_id: user.chair.id

#    can :read,              Chair do |chair|
#      user.is_admin?(chair)
#    end
#    can :accept_request,    Chair do |chair|
#      user.is_admin?(chair)
#    end
#    can :remove_from_chair, Chair do |chair|
#      user.is_admin?(chair)
#    end
#    can :set_admin,         Chair do |chair|
#      user.is_admin?(chair)
#    end
#    can :withdraw_admin,    Chair do |chair|
#      user.is_admin?(chair)
#    end
#    can :see,               Chair
#
#    cannot :reject, TimeSheet
#    cannot :accept, TimeSheet
#    cannot :see, TimeSheet
    #can :manage, own chair
    #can accept application from wimi to project
    #can remove wimis from project
  end

  def initialize_superadmin(user)
    initialize_user(user)
    can :manage, Chair
  end
end

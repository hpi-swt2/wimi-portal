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
    cannot :index, User

    can [:index, :show], Chair

    can [:index, :show], Contract, hiwi_id: user.id
    
    can [:index, :show, :leave], Project, users: { id: user.id }
    
    can [:index, :show], TimeSheet, user: { id: user.id }
    can [:edit, :update, :hand_in], TimeSheet, handed_in: false, user: { id: user.id }
    
    
    can [:new, :create], WorkDay unless user.recent_contracts.empty?
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
    
#    can [:new, :create], Project
    can [:new, :create, :index, :show], Project, chair: { chair_wimis: {user_id: user.id} }
    can :manage, Project, users: { id: user.id }
    cannot :leave, Project do |project|
      project.wimis.size == 1
    end
    
        # [:index, :show]
    can :manage, Contract, responsible_id: user.id
    can [:index, :show, :accept, :reject, :accept_reject], TimeSheet do |ts|
      can? :show, ts.contract
    end
  end

  def initialize_admin(user)
    initialize_wimi user
    
    can [:manage], Chair, chair_wimis: {user_id: user.id}
    cannot [:destroy, :new, :create], Chair
    can :manage, Contract, chair_id: user.chair.id
    
    can :manage, Project, chair_id: user.chair.id
  end

  def initialize_representative(user)
    initialize_admin user
  end

  def initialize_superadmin(user)
    initialize_user(user)
    can :manage, Chair
    can :index, User
  end
end

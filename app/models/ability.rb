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
    can [:edit, :update, :hand_in, :destroy], TimeSheet, handed_in: false, user: { id: user.id }
    can :see_hiwi_actions, TimeSheet, user: { id: user.id }
    
    can [:index, :show], WorkDay, user: { id: user.id }
    can [:create, :edit, :update, :destroy], WorkDay do |wd|
      wd.user == user and can?(:edit, wd.time_sheet)
    end
    cannot [:new, :create], WorkDay if user.recent_contracts.empty?
    can [:create, :new, :edit, :update], TimeSheet
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
    
        # [:index, :show]
    can [:index, :show, :create, :update], Contract, responsible_id: user.id
    can [:index, :show, :accept, :reject, :accept_reject], TimeSheet do |ts|
      can? :show, ts.contract
    end

    can :see_wimi_actions , TimeSheet do |ts|
      can?(:show, ts.contract) and ts.handed_in?
    end
  end

  def initialize_admin(user)
    initialize_wimi user
    
    can [:manage], Chair, chair_wimis: {user_id: user.id}
    cannot [:destroy, :new, :create], Chair
    can :manage, Contract, chair_id: user.chair.id
    
    can :manage, Project, chair_id: user.chair.id
    can :index_all, WorkDay
    can [:index, :show], WorkDay, project: { chair_id: user.chair.id }
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

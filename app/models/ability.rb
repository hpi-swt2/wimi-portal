class Ability
  include CanCan::Ability

  # alias_action :index, :show, :to => :read
  # alias_action :new, :to => :create
  # alias_action :edit, :to => :update

  def initialize(user)
    unless user.nil?
      check_functions = [:is_superadmin?, :is_admin?, :is_representative?,
                         :is_wimi?, :is_hiwi?, :is_user?]
      initialize_functions = [:initialize_superadmin, :initialize_admin, :initialize_representative,
                              :initialize_wimi, :initialize_hiwi, :initialize_user]

      check_functions.each_with_index do |check_func, index|
        if user.send check_func
          send initialize_functions[index], user
          initialize_after(user)
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

    can :new, TimeSheet if user.current_contracts.any?
    can [:index, :show], TimeSheet, user: { id: user.id }
    can [:update, :hand_in, :destroy, :create], TimeSheet, handed_in: false, user: { id: user.id }
    can :see_hiwi_actions, TimeSheet, user: { id: user.id }
    can :create_next_month, TimeSheet do |ts|
      ts.user == user and user.has_contract_for(ts.month, ts.year)
    end
    can :withdraw, TimeSheet, user: {id: user.id}, handed_in: true, status: 'pending'

    can :show, Event, user: { id: user.id }
    can [:show, :receive_email], Event, target_user: { id: user.id }
  end

  def initialize_hiwi(user)
    initialize_user user
    # hiwi is just a student with a contract,
    # has same rights as everyone
  end

  def initialize_wimi(user)
    initialize_user user
    
    can :create, Project
    can :read, Project, chair: { chair_wimis: {user_id: user.id} }
    can :manage, Project, users: { id: user.id }
    cannot :leave, Project do |project|
      project.wimis.size == 1
    end
    
    alias_action :read, :accept, :reject, :accept_reject, to: :ts_wimi_actions
    
    can [:read, :create, :update], Contract, responsible_id: user.id
    can :ts_wimi_actions, TimeSheet, contract: { responsible_id: user.id }
    can :see_wimi_actions, TimeSheet, contract: { responsible_id: user.id }, handed_in: true
    
    # allow access to time sheets and contracts of other wimis if time sheet is 'pending'
    can [:ts_wimi_actions, :see_wimi_actions], TimeSheet, status: 'pending', contract: { chair_id: user.chair.id }
    can :read, Contract, chair_id: user.chair.id, time_sheets: { status: 'pending' }

    can :show, Event do |e|
      (e.related_projects & user.projects).any?
    end
  end

  def initialize_admin(user)
    initialize_wimi user
    
    can [:manage], Chair, chair_wimis: {user_id: user.id}
    cannot [:destroy, :new, :create], Chair
    can :manage, Contract, chair_id: user.chair.id
    
    can :manage, Project, chair_id: user.chair.id

    can :show, Event do |e|
      e.related_chair == user.chair
    end
  end

  def initialize_representative(user)
    initialize_admin user
  end

  def initialize_superadmin(user)
    initialize_user(user)
    can :manage, Chair
    can :index, User
  end

  # Ensure these rules are applied last
  def initialize_after(user)
    cannot :receive_email, Event, user: { id: user.id }
  end
end

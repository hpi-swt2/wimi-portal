class Ability
  include CanCan::Ability

  def initialize(user)
    unless user.nil?
      alias_action :create, :read, :update, :destroy, :to => :crud
      check_functions = [ :is_admin?, :is_representative?,
        :is_wimi?, :is_superadmin?, :is_hiwi?, :is_user? ]
      initialize_functions = [ :initialize_admin, :initialize_representative,
        :initialize_wimi, :initialize_superadmin, :initialize_hiwi, :initialize_user ]

      check_functions.each_with_index do |check_func, index|
        if user.send check_func
          self.send initialize_functions[index], user
          return
        end
      end
    end
  end

  def initialize_user(user)
    can :index, Chair
    can :apply, Chair
    # can :accept_invitation, Project
  end

  def initialize_hiwi(user)
    # can :accept_invitation, Project
    # can :manage, Stundenzettel
  end

  def initialize_wimi(user)
    initialize_user user
    can :crud, Project
    can :invite_user, Project do |project|
      project.users.include? user
    end
    #can :set aktive/inaktive
    #can :manage, Documents of hiwis in own projects
  end

  def initialize_representative(user)
    initialize_wimi user
    can :read,      Chair
    can :requests,  Chair do |chair|
      user.is_representative?(chair)
    end
    #can show, Holidays of chair members
  end

  def initialize_admin(user)
    initialize_wimi user
    can :read,              Chair
    can :accept_request,    Chair
    can :remove_from_chair, Chair
    can :set_admin,         Chair
    can :withdraw_admin,    Chair
    #can :manage, own chair
    #can accept application from wimi to project
    #can remove wimis from project
  end

  def initialize_superadmin(user)
    initialize_admin user
    can :manage,      Chair
    cannot  :show,    Chair
    #assign representative/admin role to user
  end
end
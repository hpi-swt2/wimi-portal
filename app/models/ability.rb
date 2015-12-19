class Ability
  include CanCan::Ability

  def initialize(user)
    unless user.nil?
      initialize_admin user and return if user.is_admin?
      initialize_representative user and return if user.is_representative?
      initialize_wimi user and return if user.is_wimi?

      initialize_superadmin user and return if user.is_superadmin?
      initialize_hiwi user and return if user.is_hiwi?
      initialize_user user and return if user.is_user?
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
    #can :set aktive/inaktive
    #can :manage, Documents of hiwis in own projects
  end

  def initialize_representative(user)
    can :read,      Chair
    can :requests,  Chair do |chair|
      user.is_representative?(chair)
    end
    #can show, Holidays of chair members
  end

  def initialize_admin(user)
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
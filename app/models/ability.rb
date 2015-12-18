class Ability
  include CanCan::Ability

  def initialize(user)
    unless user.nil?

      initialize_admin user if user.is_admin?
      initialize_representative user if user.is_representative?
      initialize_wimi user and return if user.is_wimi?

      initialize_superadmin user and return if user.is_superadmin?
      initialize_hiwi user and return if user.is_hiwi?
      initialize_user user and return if user.is_user?
    end
  end

  def initialize_superadmin(user)
    can     :create,  Chair
    can     :edit,    Chair
    #assign representative/admin role to user
  end

  def initialize_admin(user)
    #can :manage, own chair
    #can accept application from wimi to project
    #can remove wimis from project
    initialize_wimi user
  end

  def initialize_representative(user)
    #can accept, Anträge
    #can show, Holidays of chair members
  end

  def initialize_wimi(user)
    can :crud, Project
    #can :set aktive/inaktive
    #can :manage, Documents of hiwis in own projects
  end

  def initialize_hiwi(user)
    # can :accept_invitation, Project
    # can :manage, Stundenzettel
  end

  def initialize_user(user)
    can :apply, Chair
    # can :accept_invitation, Project
  end
end

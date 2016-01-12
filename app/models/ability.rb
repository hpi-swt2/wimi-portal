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
    can :manage, Project do |project|
      project.users.include?(user)
    end
    can :invite_user, Project do |project|
      project.users.include? user
    end
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
    can :edit, Chair do |chair|
      chair.admins.include?(user.chair_wimi)
    end
    #can :manage, own chair
    #can accept application from wimi to project
    #can remove wimis from project
  end

  def initialize_superadmin(user)
    can :manage,      Chair
    cannot  :show,    Chair
    #assign representative/admin role to user
  end
end

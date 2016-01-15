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

  def initialize_user(_user)
    can :index, Chair
    can :apply, Chair
    can :read, Project do |project|
      project.public
    end
    can :create, ProjectApplication
    # can :accept_invitation, Project
  end

  def initialize_hiwi(user)
    cannot :create, ProjectApplication do |project_application|
      user.projects.exists?(project_application.project_id)
    end
    # can :accept_invitation, Project
    # can :manage, Stundenzettel
  end

  def initialize_wimi(user)
    initialize_user user
    can :read, Holiday do |holiday|
      holiday.user == user
    end
    can :read, TravelExpenseReport do |r|
      r.user == user
    end
    can :create, Project
    can :manage, Project do |project|
      project.users.include?(user)
    end
    can :invite_user, Project do |project|
      project.users.include? user
    end
    can :manage, ProjectApplication do |project_application|
      user.projects.exists?(project_application.project_id)
    end
    cannot :create, ProjectApplication
    #can :set aktive/inaktive
    #can :manage, Documents of hiwis in own projects
  end

  def initialize_representative(user)
    initialize_wimi user
    can :read,      Holiday do |holiday|
      user.is_representative?(holiday.user.chair)
    end
    can :read,      TravelExpenseReport do |r|
      user.is_representative?(r.user.chair)
    end
    can :read,      Chair do |chair|
      user.is_representative?(chair)
    end
    can :requests,  Chair do |chair|
      user.is_representative?(chair)
    end
    can :add_requests,  Chair do |chair|
      user.is_representative?(chair)
    end
    can :requests_filtered,  Chair do |chair|
      user.is_representative?(chair)
    end
    #can show, Holidays of chair members
  end

  def initialize_admin(user)
    initialize_wimi user
    can :read,              Chair do |chair|
      user.is_admin?(chair)
    end
    can :accept_request,    Chair do |chair|
      user.is_admin?(chair)
    end
    can :remove_from_chair, Chair do |chair|
      user.is_admin?(chair)
    end
    can :set_admin,         Chair do |chair|
      user.is_admin?(chair)
    end
    can :withdraw_admin,    Chair do |chair|
      user.is_admin?(chair)
    end
    #can :manage, own chair
    #can accept application from wimi to project
    #can remove wimis from project
  end

  def initialize_superadmin(_user)
    can :manage,      Chair
    cannot :show,    Chair
    #assign representative/admin role to user
  end
end

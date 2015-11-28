class Ability
  include CanCan::Ability

  def initialize(user)
    unless user.nil?
      can :read, Chair

      initialize_superadmin user and return if user.superadmin?
      initialize_admin user and return if user.admin?
      initialize_wimi user and return if user.wimi?
      initialize_hiwi user and return if user.hiwi?
      initialize_user user and return if user.user?
    end
  end

  def initialize_superadmin(user)
    can :manage, :all
  end

  def initialize_admin(user)
    can :manage, user.projects
    can :manage, ProjectApplication do |project_application|
      user.projects.exists?(project_application.project_id)
    end
    cannot :create, ProjectApplication
  end

  def initialize_wimi(user)
    can :manage, user.projects
    can :manage, ProjectApplication do |project_application|
      user.projects.exists?(project_application.project_id)
    end
    cannot :create, ProjectApplication
  end

  def initialize_hiwi(user)

  end

  def initialize_user(user)
    can :create, ProjectApplication
  end
end

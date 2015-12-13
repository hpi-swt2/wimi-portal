class Ability
  include CanCan::Ability

  def initialize(user)
    unless user.nil?
      initialize_user
      initialize_superadmin user and return if user.is_superadmin?
      initialize_admin user and return if user.is_admin?
      initialize_wimi user and return if user.is_wimi?
      initialize_hiwi user and return if user.is_hiwi?
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

  def initialize_user
    cannot :manage, :all
    can :create, ProjectApplication
  end
end

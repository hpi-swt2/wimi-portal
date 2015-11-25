class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new # guest user (not logged in)
    if user.is?('superadmin')
      can :manage, :all
    elsif user.is?('admin')
      can :manage, user.chairs
      can :manage, user.projects
      can :manage, ProjectApplication do |project_application|
        user.projects.exists?(project_application.project_id)
      end
      cannot :create, ProjectApplication
    elsif user.is?('wimi')
      can :read, user.chairs
      can :manage, user.projects
      can :manage, ProjectApplication do |project_application|
        user.projects.exists?(project_application.project_id)
      end
      cannot :create, ProjectApplication
    elsif user.is?('hiwi')
      can :read, user.chairs
    elsif user.is?('user')
      can :read, Chair
      can :create, ProjectApplication
    else
      cannot :all
    end
  end
end

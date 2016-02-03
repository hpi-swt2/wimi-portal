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

    can :superadmin_index, User
  end

  def initialize_user(user)
    can :see, Project
    can :apply, Project
    can :index, Chair
    can :apply, Chair
    can :read, Project do |project|
      project.public
    end
    can :create, ProjectApplication
    can :show, User
    can :read, User
    can :update, User do |_user|
      _user == user
    end
    can :edit, User do |_user|
      _user == user
    end
    can :upload_signature, User do |_user|
      _user == user
    end
    can :delete_signature, User do |_user|
      _user == user
    end
    can :user_exists, User
    can :resource_name, User
    can :resource, User
    can :devise_mapping, User
    can :language, User
    can :set_user, User

    can :accept_invitation, Project do |project|
      Invitation.select{ |i| i.user == user && i.project == project}
    end
    can :decline_invitation, Project do |project|
      Invitation.select { |i| i.user == user && i.project == project }
    end
  end

  def initialize_hiwi(user)
    initialize_user user

    can :read, Project
    cannot :create, ProjectApplication do |project_application|
      user.projects.exists?(project_application.project_id)
    end
    can :sign_user_out, Project do |project|
      project.users.include? user
    end
    can :read,  TimeSheet.select { |t| t.user == user}
    can :add_working_hours, Project do |project|
      project.users.include? user
    end
    # can :accept_invitation, Project
    # can :manage, Stundenzettel
  end

  def initialize_wimi(user)
    initialize_user user

    alias_action :create, :read, :update, :destroy, to: :crud

    can :read, Project
    can :create, Project
    can :manage, Project do |project|
      project.users.include?(user)
    end
    can :edit, Project do |project|
      project.users.include?(user)
    end
    can :invite_user, Project do |project|
      project.users.include? user
    end
    can :sign_user_out, Project do |project|
      project.users.include? user
    end
    cannot :add_working_hours, Project
    can :manage, ProjectApplication do |project_application|
      user.projects.exists?(project_application.project_id)
    end
    cannot :create, ProjectApplication
    can :new, Holiday
    can :create, Holiday
    can :new, Expense
    can :create, Expense
    can :new, Trip
    can :create, Trip
    can :read, Trip.select { |t| t.user == user }
    can :update, Trip.select { |t| t.user == user }
    can :edit, Trip.select { |t| t.user == user }
    can :hand_in, Trip.select { |t| t.user == user }
    can :destroy, Trip.select { |t| t.user == user }
    can :see_trips, User do |u|
      u == user
    end
    can :crud, Holiday.select { |h| h.user == user }
    can :file, Holiday.select { |h| h.user == user }

    can :manage, Expense.select { |t| t.user == user }
    can :see_holidays, User do |u|
      u == user
    end

    can :reject, TimeSheet.select { |t| Project.select {|p| p.users.include? user &&  p == t.project }}
    can :accept, TimeSheet.select { |t| Project.select {|p| p.users.include? user &&  p == t.project }}
    can :read, TimeSheet.select { |t| Project.select {|p| p.users.include? user &&  p == t.project }}
    #can :set aktive/inaktive
    #can :manage, Documents of hiwis in own projects
  end

  def initialize_representative(user)
    initialize_wimi user

    can :see_holidays, User do |chair_user|
      chair_user.chair == user.chair
    end
    can :see_trips,    User do |chair_user|
      chair_user.chair == user.chair
    end

    can :reject, Holiday.select {|h| h.user != user}
    can :accept, Holiday.select {|h| h.user != user}
    can :read,   Holiday do |h|
      user.is_representative?(h.user.chair)
      h.status != 'saved' && h.status != 'declined'
    end

    can :read,      Trip.select { |t| user.is_representative?(t.user.chair) }
    can :reject,    Trip
    can :accept,    Trip
    can :edit_trip, Trip do |trip|
      trip.status != 'saved'
    end
    can :read,      Trip do |t|
      user.is_representative?(t.user.chair)
      t.status != 'saved' && t.status != 'declined'
    end

    can :read, Expense.select { |t| user.is_representative?(t.user.chair) }

    can :see,               Chair
    can :read,              Chair do |chair|
      user.is_representative?(chair)
    end
    can :requests,          Chair do |chair|
      user.is_representative?(chair)
    end
    can :add_requests,      Chair do |chair|
      user.is_representative?(chair)
    end
    can :requests_filtered, Chair do |chair|
      user.is_representative?(chair)
    end

    cannot :reject, TimeSheet
    cannot :accept, TimeSheet
    cannot :see, TimeSheet
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
    can :see,               Chair

    cannot :reject, TimeSheet
    cannot :accept, TimeSheet
    cannot :see, TimeSheet
    #can :manage, own chair
    #can accept application from wimi to project
    #can remove wimis from project
  end

  def initialize_superadmin(_user)
    can     :manage,   Chair
    cannot  :see,      Chair
    cannot  :show,     Chair
    can     :show,     User do |user|
      user == _user
    end
    can :update, User do |user|
      _user == user
    end
    can :edit, User do |user|
      _user == user
    end
    can :upload_signature, User do |user|
      _user == user
    end
    can :delete_signature, User do |user|
      _user == user
    end
    can :user_exists, User
    can :resource_name, User
    can :resource, User
    can :devise_mapping, User
    can :language, User
    can :set_user, User

    cannot  :create,   ProjectApplication
    #assign representative/admin role to user
  end
end

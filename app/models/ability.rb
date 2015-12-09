class Ability
  include CanCan::Ability

  def initialize(user)
    unless user.nil?

      initialize_superadmin user and return if user.superadmin?
      initialize_admin user and return if user.admin?
      initialize_wimi user and return if user.wimi?
      initialize_hiwi user and return if user.hiwi?
      initialize_user user and return if user.user?
    end
  end

  def initialize_user(user)
    cannot :create, Project
  end
end

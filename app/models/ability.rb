class Ability
  include CanCan::Ability

  def initialize(user)
    unless user.nil?
      cannot :manage, :all

      initialize_admin user if user.is_admin?
      initialize_representative user if user.is_representative?
      initialize_wimi user and return if user.is_wimi?

      initialize_superadmin user and return if user.is_superadmin?
      initialize_hiwi user and return if user.is_hiwi?
      initialize_user user and return if user.is_user?
    end
  end

  def initialize_superadmin(user)
    cannot  :manage,  :all
    can     :create,  Chair
    can     :edit,    Chair
  end

  def initialize_admin(user)
    cannot  :manage,  :all
  end

  def initialize_representative(user)
    cannot  :manage,  :all
  end

  def initialize_wimi(user)
    cannot  :manage,  :all
    can     :create,  Project
    can     :edit,    Project
    can     :destroy, Project
    can     :update,  Project
  end

  def initialize_hiwi(user)
    cannot  :manage,  :all
  end

  def initialize_user(user)
    cannot  :manage,  :all
  end
end
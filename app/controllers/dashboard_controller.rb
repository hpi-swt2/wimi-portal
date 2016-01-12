class DashboardController < ApplicationController
  def index
    @notifications = []

    if current_user.is_superadmin?
      @notifications += Event.where(seclevel: Event.seclevels[:superadmin])
    end

    if current_user.is_admin?
      @notifications += Event.where(seclevel: Event.seclevels[:admin])
    end

    #add all other Events
    # TODO: implement security tests

    @notifications += Event.where(seclevel: Event.seclevels[:representative])
    @notifications += Event.where(seclevel: Event.seclevels[:user])
    @notifications += Event.where(seclevel: Event.seclevels[:wimi])

    @notifications.delete_if { |event| event.is_hidden_by(current_user) }
    @invitations = Invitation.where(user: current_user)
  end
end

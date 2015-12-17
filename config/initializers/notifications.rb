ActiveSupport::Notifications.subscribe "event.admin.rights_changed" do |name,start,finish,id,payload|
  EventAdminRightsChanged.create! do |event|
    event.admin = payload[:admin]
    event.user = payload[:user]
    event.user_is_admin = payload[:user_is_admin]
  end
end


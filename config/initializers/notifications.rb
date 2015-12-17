# Event Template:
#
# ActiveSupport::Notifications.subscribe "<event_name>" do |name,start,finish,id,payload|
# --handle your event here--
# --for example make a new model (MyEvent)  and save the payload within:
#   MyEvent.create! do |event|
#     event.attribute = payload[:key]
#   end
# end
# 
# To trigger the event call the instrument function where your event should be created (for example in the controller) with
#
# ActiveSupport::Notifications.instrument("<event_name>", { :key => value })
#
# where { :key => value } can be any custom hashmap you like.
# this map will be available through the payload variable in the subscribe function
#
# add new events here

ActiveSupport::Notifications.subscribe "event.admin.rights_changed" do |name,start,finish,id,payload|
  EventAdminRightsChanged.create! do |event|
    event.admin = payload[:admin]
    event.user = payload[:user]
    event.user_is_admin = payload[:user_is_admin]
  end
end


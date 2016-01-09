# This call interrupts all Events
#
# To trigger an event call the instrument function where your event should be created (for example in the controller) with
#
# ActiveSupport::Notifications.instrument("event", { trigger: object.id, target: object2.id, chair: chair, seclevel: <seclevel> , type: "EventName"})
#
# You will have to create a new Model that inherits from Event (look at EventAdminAdded for an example)
# Your event will be automatically displayed on the dashboard (hooks for that are in dashboard controller and view)
#
# In order for it to display correctly you have to add a partial that renders your Event
# (look in app/views/event_admin_addeds/_event_admin_added.html.erb for an example)
#
# !!! make sure that the folder name is pluralized, otherwise rails wont find it (even if it sounds stupid, like event_admin_addeds )

ActiveSupport::Notifications.subscribe "event" do |name,start,finish,id,payload|
  Event.create! do |event|
    event.trigger_id = payload[:trigger]
    event.target_id = payload[:target]
    event.chair = payload[:chair]
    event.project = payload[:project]
    event.seclevel = payload[:seclevel]
    event.type = payload[:type]
  end
end

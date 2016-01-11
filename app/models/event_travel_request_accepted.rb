# == Schema Information
#
# Table name: events
#
#  id         :integer          not null, primary key
#  trigger_id :integer
#  target_id  :integer
#  chair_id   :integer
#  seclevel   :integer
#  type       :string
#

class EventTravelRequestAccepted < Event
  before_save :set_defaults
  belongs_to :target, class_name: 'User'
  belongs_to :trigger, class_name: 'Trip'

  def set_defaults
      self.seclevel = :wimi
      self.type = "EventTravelRequestAccepted"
  end
end

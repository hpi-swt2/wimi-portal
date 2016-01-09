class EventTravelRequestAccepted < Event
  before_save :set_defaults
  belongs_to :target, class_name: 'User'

  def set_defaults
      self.seclevel = :wimi
      self.type = "EventTravelRequestAccepted"
  end
end

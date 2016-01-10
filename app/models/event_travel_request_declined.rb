class EventTravelRequestDeclined < Event
  before_save :set_defaults
  belongs_to :target, class_name: 'User'
  belongs_to :trigger, class_name: 'Trip'

  def set_defaults
      self.seclevel = :wimi
      self.type = "EventTravelRequestDeclined"
  end
end

class EventTravelRequestDeclined < Event
  before_save :set_defaults
  belongs_to :user, foreign_key: 'target_id'
  belongs_to :trip, foreign_key: 'trigger_id'

  def set_defaults
      self.seclevel = :wimi
      self.type = "EventTravelRequestDeclined"
  end
end

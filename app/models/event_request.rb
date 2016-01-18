class EventRequest < Event
  before_validation :set_defaults

  def set_defaults
    self.seclevel = :representative
    self.type = 'EventRequest'
  end
end

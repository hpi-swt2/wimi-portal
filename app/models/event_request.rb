class EventRequest < Event
  before_save :set_defaults

  def set_defaults
    self.seclevel = :representative
    self.type = 'EventRequest'
  end
end

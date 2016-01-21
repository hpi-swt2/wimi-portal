class EventChairApplication < Event
  before_validation :set_defaults

  def set_defaults
    self.seclevel = :admin
    self.type = 'EventChairApplication'
  end
  end

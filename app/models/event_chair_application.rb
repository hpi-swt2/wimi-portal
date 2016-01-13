class EventChairApplication < Event
    before_save :set_defaults

    def set_defaults
      self.seclevel = :admin
      self.type = 'EventChairApplication'
    end
  end

class EventAdminRight < Event
  before_validation :set_defaults
  belongs_to :target, class_name: 'User'

  def set_defaults
    self.seclevel = :admin
    self.type = 'EventAdminRight'
  end
end

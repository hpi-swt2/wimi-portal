class EventProjectInvitation < events
  before_save :set_defaults
  belongs_to :target, class_name: 'User'

  def set_defaults
    self.seclevel = :hiwis
    self.type = "EventProjectInvitation"
  end
end

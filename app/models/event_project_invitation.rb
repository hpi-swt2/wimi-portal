class EventProjectInvitation < Event
  before_save :set_defaults
  belongs_to :target, class_name: 'User'
  belongs_to :trigger, class_name: 'Invitation'  

  def set_defaults
      self.seclevel = :hiwi
      self.type = "EventProjectInvitation"
  end
end

class EventProjectInvitation < Event
  before_save :set_defaults
  belongs_to :user, foreign_key: 'target_id'
  belongs_to :invitation, foreign_key: 'trigger_id'

  def set_defaults
      self.seclevel = :hiwi
      self.type = "EventProjectInvitation"
  end
end

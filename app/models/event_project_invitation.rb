class EventProjectInvitation < Event
  before_save :set_defaults
  belongs_to :target, class_name: 'User'

  validates :invitation, presence: true

  def set_defaults
      self.seclevel = :hiwi
      self.type = "EventProjectInvitation"
  end
end

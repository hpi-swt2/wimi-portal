# == Schema Information
#
# Table name: events
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  target_user_id :integer
#  object_id      :integer
#  object_type    :string
#  created_at     :datetime
#  type           :integer
#

class Event < ActiveRecord::Base
  # need this to prevent rails from doing single inheritance
  # because we have a field 'type'
  self.inheritance_column = nil

  belongs_to :user
  belongs_to :target_user, class_name: 'User'
  belongs_to :object, polymorphic: true

  # This enum should only be appended to, the order (the assigned int)
  # is responsible for mapping to the correct event type
  enum type: [ :time_sheet_hand_in, :time_sheet_accept, :time_sheet_decline,
    :project_create, :project_join, :project_leave, :chair_join, :chair_leave,
    :chair_add_admin, :contract_create, :contract_extend
  ]

  validates_presence_of :user, :target_user, :object

  after_create :send_mail

  def self.add(type, user, object, target_user)
    event = self.new({ type: type, user: user, object: object, target_user: target_user})
    if event.save
      return event
    end
    logger.error 'Could not save event: #{event.inspect}'
    return nil
  end

  def self.recent_events_for(obj)
    Event.where(object: obj).limit(3).order(created_at: :desc)
  end

  def users_want_mail
    User.all.select do |u|
      (Ability.new(u).can? :receive_email, self) && u.wants_mail_for(type_id)
    end
  end

  def send_mail
    self.users_want_mail.each do |user|
      ApplicationMailer.notification(self, user)
    end
  end

  def type_id
    Event.types[self.type]
  end

  # Some events are only relevant for people in a project
  def related_projects
    case self.object
      when Project
        [self.object]
      when TimeSheet
        self.object.projects
      else
        []
    end
  end

  # Some events are only relevant admins of a chair
  def related_chair
    case self.object
      when Chair
        self.object
      when Contract
        self.object.chair
      else
        nil
    end
  end
end

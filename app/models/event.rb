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

  enum type: [ :time_sheet_hand_in, :time_sheet_accept, :time_sheet_decline,
    :project_create, :project_join, :project_leave, :chair_join, :chair_leave, :chair_add_admin,
    :contract_create, :contract_extend
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

  def users_want_mail
    User.all.select do |user|
      a = Ability.new(user)
      if a.can? :show, self
        ret = user.event_settings.include? Event.types[self.type]
      else
        ret = false
      end
      ret
    end
  end

  def send_mail
    self.users_want_mail.each do |user|
      MailNotifier.notification(self, user)
    end
  end

  def message
    return I18n.t("event.#{self.type}",
      user: self.user.name,
      # The I18n interpolation key cannot be the reserved name 'object'
      obj: self.object.name,
      target_user: self.target_user.name)
  end

  def type_id
    Event.types[self.type]
  end
end

class Event < ActiveRecord::Base
	# need this to prevent rails from doing single inheritance
	# because we have a field 'type'
	self.inheritance_column = nil

	belongs_to :user
	belongs_to :target_user, class_name: 'User'
	belongs_to :object, polymorphic: true

	enum type: [ :default, :time_sheet_hand_in, :time_sheet_accept, :time_sheet_decline,
		:project_create, :project_join, :project_leave, :chair_join, :chair_leave, :chair_add_admin,
		:contract_create, :contract_extend
	]

	validates_presence_of :user, :target_user

	after_commit :send_mail, on: :create

	def self.add(type, user, object, target_user)
		if object != nil
			event = self.new({ type: type, user: user, object: object, target_user: target_user})
		else
			event = self.new({ type: type, user: user, target_user: target_user})
		end
		if event.valid?
			event.save
			return event
		end
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
		users_to_mail = self.users_want_mail
		users_to_mail.each do |user|
			MailNotifier.notification(self, user)
		end
	end

	def message
		if self.object != nil
			return I18n.t("event.#{self.type}",
				user: self.user.name,
				# The I18n interpolation key cannot be the reserved name 'object'
				obj: self.object.name,
				target_user: self.target_user.name)
		else
			return I18n.t("event.#{self.type}",
				user: self.user.name,
				target_user: self.target_user.name)
		end
	end
end
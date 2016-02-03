class UserEmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i or value == User::INVALID_EMAIL
      record.errors[attribute] << (options[:message] || I18n.t('users.no_email'))
    end
  end
end
